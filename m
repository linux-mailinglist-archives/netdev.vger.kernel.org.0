Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4527EBF693
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 18:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727465AbfIZQVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 12:21:05 -0400
Received: from mail-io1-f44.google.com ([209.85.166.44]:32992 "EHLO
        mail-io1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfIZQVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 12:21:05 -0400
Received: by mail-io1-f44.google.com with SMTP id z19so8198546ior.0;
        Thu, 26 Sep 2019 09:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=QJ4hddZZaCwzQ+urngLpzSBE5Lf+YMOX+zDksoDMMVc=;
        b=p3Ef7gDVoD0fgo0Sf4pwFv3Q0EAo/Q1dAmBcMiTosyfrETgIyoGlcxBs5nOGrhd36p
         uoSNZJmj1brKW4FuwI8i+ZXe90LL3O41GZVRV4Dq7XguvehC9wzdjWaCmBtOrP1HzIDE
         Q/NgzMYEmrespkFCIVQdBUd3q6AzEYe6S03hwkCrYo82w/tkbgjIlGQNKxLErGWE+mn2
         QKdJfMebk6r5P36VjKbhJG30kK4WJPRPZWQH7XrJ3CaZwwucebIzhTMbwWlg4fVATu8B
         OQhWZ+UXcFYmfFPvOZ6PEQ/ThRF75tgiKLBTw3Y9tCQMcxfeLC3jeO8LvcK3ZMoUirjb
         p6fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=QJ4hddZZaCwzQ+urngLpzSBE5Lf+YMOX+zDksoDMMVc=;
        b=ZzuRtflI96IGIW3GS6EZvCazrgjEoBgGKa/U3VMYTu8juqDS1+PWg6/5cNxZxkbHNM
         NSBbYzaiV8KGj6B0v9BnmjUWML5K1efHZw+QH4r1vAptbyo6Sy0vU34h3A9jmW6ErG34
         loVHN2yGuLB/xpWEnf0wcZPh+k5L/rx/AQd8Y/fy5LOrGJIvh65rTbdCwc9mmVG2WCtY
         n8ipGOUcsag8tJDJjLEVLxe9PvxKc6EtJwGqBD4LUPX11x6EG6IGjRlUdrfeOCvgTsI9
         7SB0RrK9bjpiPVfCk/BOavvaluD/f8JFkH17b0PMZt42N3yScCTd+hs6cJkRWjHwcc8e
         akdQ==
X-Gm-Message-State: APjAAAVQkYvRtfYx9dQZZn6ce3HS775wvqkLu54ugAbtDGlarDt5ipf1
        qd3ski3RcLaWLjC14L6eTjc=
X-Google-Smtp-Source: APXvYqz6t1kCxh8lTNZOhE7J7L3/nqpQXJlXfCPWyk91LwCf3w3QZAZ+J/Ep52xFAx5bjyPdXi1bVQ==
X-Received: by 2002:a5d:8b12:: with SMTP id k18mr3750297ion.93.1569514864037;
        Thu, 26 Sep 2019 09:21:04 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id t17sm1127473ioc.18.2019.09.26.09.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2019 09:21:03 -0700 (PDT)
Date:   Thu, 26 Sep 2019 09:20:56 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Allan Zhang <allanzhang@google.com>, daniel@iogearbox.net,
        songliubraving@fb.com, netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Allan Zhang <allanzhang@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Eric Dumazet <edumazet@google.com>
Message-ID: <5d8ce5686ef9f_34102b0cab5805c4b6@john-XPS-13-9370.notmuch>
In-Reply-To: <20190925234312.94063-2-allanzhang@google.com>
References: <20190925234312.94063-1-allanzhang@google.com>
 <20190925234312.94063-2-allanzhang@google.com>
Subject: RE: [PATCH 1/1] bpf: Fix bpf_event_output re-entry issue
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allan Zhang wrote:
> BPF_PROG_TYPE_SOCK_OPS program can reenter bpf_event_output because it can
> be called from atomic and non-atomic contexts since we don't have
> bpf_prog_active to prevent it happen.
> 
> This patch enables 3 level of nesting to support normal, irq and nmi
> context.
> 
> We can easily reproduce the issue by running neper crr mode with 100 flows
> and 10 threads from neper client side.
> 
> Here is the whole stack dump:
> 
> [  515.228898] WARNING: CPU: 20 PID: 14686 at kernel/trace/bpf_trace.c:549 bpf_event_output+0x1f9/0x220
> [  515.228903] CPU: 20 PID: 14686 Comm: tcp_crr Tainted: G        W        4.15.0-smp-fixpanic #44
> [  515.228904] Hardware name: Intel TBG,ICH10/Ikaria_QC_1b, BIOS 1.22.0 06/04/2018
> [  515.228905] RIP: 0010:bpf_event_output+0x1f9/0x220

[...]
 
> Fixes: a5a3a828cd00 ("bpf: add perf event notificaton support for sock_ops")
> 
> Effort: BPF
> Signed-off-by: Allan Zhang <allanzhang@google.com>
> Reviewed-by: Stanislav Fomichev <sdf@google.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> ---

LGTM thanks.

Acked-by: John Fastabend <john.fastabend@gmail.com>
