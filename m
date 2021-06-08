Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870743A0493
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 21:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237439AbhFHTlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 15:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236519AbhFHTlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 15:41:06 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF234C06114E;
        Tue,  8 Jun 2021 12:30:09 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id b9so20916949ilr.2;
        Tue, 08 Jun 2021 12:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=Q+AFeIk+1Wo3OVzoBBOFsZcJ17Rk8amBn+Q22ssWRXw=;
        b=Zc9I5aRcgtPCDMrkR6VOcBCYuquTbEOH4P4oHOHpvO5+mDbYZLTyM+Yqfme0cka3d0
         BxFciO0yN5EVbhxTVwCvTu+ayxf9QfS8omsqyz80S1JPjyRJpvov2gEx5XchOg7Ms3vl
         jDhz1j2heTmgbrZALwDoSGyPPe9m1awhrvfVC+TjRdnlGjBxtEQhG9Ajnnti7BzidUNX
         TbDOYTmYNmyoLoONGCVQjr/fpAaY47PcwiBOUb9z18kbrdh7MT/j0SIfN1qCqpaBAtx7
         QrTLltxLM0XLjP25Obbottq3s68cUiciJcLjw1BXBN2WWxPlbjXN9IYijZic3evu0iqC
         lD1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=Q+AFeIk+1Wo3OVzoBBOFsZcJ17Rk8amBn+Q22ssWRXw=;
        b=YQtSIsaSE9F+mUK8QLU4Wfw50UXbtP2rMOCLr5bcLKp3uSuJ2NUTxK0OYT4WZfwUYv
         yOF2NbgWyZT50Bn9R3cPCLzrD5V2U7Eu4BzqyqnKic1dzVZyUHkB3n7Db12oNRtx7xc9
         EPIErTLJqN+CgYggYIvry12qGY6x26423DvFilFB4kfpzpXmvPwTN/jM9BvARA2w6jQx
         Nnsy6c5cSy+6SVJB0KqGw/f1wL+zaRxF63aNfDVUqV0EliCxIopoVH0zc/2xUiwbYnLQ
         VbrQAigBd99ZaeJGv8VB1rtI1F5d1NoBhyBu9hrjZeUiZDvT+aj8jY+Emxz29glIlslg
         lvfA==
X-Gm-Message-State: AOAM533gb6hoOEt/S/XzdHYKv1xQIc+8BzdAQAKD31Ck7LKJsXO8g8XY
        TEo2hGZ07W9VMn86NYcDfbU=
X-Google-Smtp-Source: ABdhPJywl+IoZFzEkRAmQFjsbeFRXnO3PbVBlb9t1Nf0HSFjUvZGyfUt0rMaS/eh2GzZ/avxUbO86Q==
X-Received: by 2002:a6b:4e0a:: with SMTP id c10mr19649163iob.183.1623180609175;
        Tue, 08 Jun 2021 12:30:09 -0700 (PDT)
Received: from [127.0.1.1] ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id o18sm364277ioh.35.2021.06.08.12.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 12:30:08 -0700 (PDT)
Subject: [PATCH bpf  0/2] bpf fix for mixed tail calls and subprograms
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com
Cc:     john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, maciej.fijalkowski@intel.com
Date:   Tue, 08 Jun 2021 12:29:57 -0700
Message-ID: <162318053542.323820.3719766457956848570.stgit@john-XPS-13-9370>
User-Agent: StGit/0.23-85-g6af9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We recently tried to use mixed programs that have both tail calls and
subprograms, but it needs the attached fix. Also added a small test
addition that will cause the failure without the fix.

Thanks,
John

---

John Fastabend (2):
      bpf: Fix null ptr deref with mixed tail calls and subprogs
      bpf: selftest to verify mixing bpf2bpf calls and tailcalls with insn patch


 .../selftests/bpf/progs/tailcall_bpf2bpf4.c     | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--

