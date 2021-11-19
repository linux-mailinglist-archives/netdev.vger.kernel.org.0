Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D7745762E
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 19:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234324AbhKSSRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 13:17:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232509AbhKSSRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 13:17:35 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3786C061574;
        Fri, 19 Nov 2021 10:14:33 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id l8so11084572ilv.3;
        Fri, 19 Nov 2021 10:14:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OK3QGipzsz8RDdhQvlPyrhT7IAJzli5HzLGRrKoL5Vg=;
        b=qTOqAO/pyZp63zOi9SFWwHNcoFqmjJbp/LafzEIXISFb+9AqhNZH8lzOyLV9chE8TE
         kwQXRqhMggIv00ZWnqKnSLoNtKDR04tD17+ewT1kEx19hOUogTo+/OTCDR8CrK6SjUAM
         pGNSuyq49TubS/iYT8/JU/i9WeVjfFLuOiZ9dNEWjeBwHXiU9UpiTVWIoqSP4IolWUvw
         XGlIP9Mj7jS75GQwFPiEiAF0VS/Y90J3u3Ki3sKIww6oYz82gb0zf/Vzpyg/j8hgSaBq
         f6e2oOHfo9iBN2bbyDT7WrWHDiNKZH1kpaIOPxRc396RTO4NUh7NfVESZW0YRJCbBSy0
         iL5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OK3QGipzsz8RDdhQvlPyrhT7IAJzli5HzLGRrKoL5Vg=;
        b=iy/8zt32Tmy1JvyZnCIjXXqvDQ8G84UzAYqPCzgCbKo1IHXchMzJ5G5cmFgWv8SO7j
         Ceh5pS1sCb9ZDbLswGadj6soPWxjAX0kHL1GWObzJTNg1Ug9rqXTheoyYQMSu9YM5xsu
         k7XvXEzLx4W6b3aADVKjkzAya+tx+bQVLX+4MESv4wP5GrRowsnKvfSH1IN0LZAzl0iE
         C78MHDY1Yq0sY1N48N/5c7oyyZj93IJOkTcq2flZJb+UYCxcdKEEADcEYHS9da2kTxpH
         bvk0rEpn6VngV1E9dCWOnAVgWyH5wmkPEE5qKcAsnOSqwf7pIyTmabdqEAZDQaH5OX0e
         a0vA==
X-Gm-Message-State: AOAM531lM+sRhefHsOsGlSh4nL0kkQ/SsfOQFWlxOadz5pWjjPZ4vIXu
        ma1Q5Fd4znKuNNuh6ghDcv8=
X-Google-Smtp-Source: ABdhPJxCemD9+w8GakbzPg5tckRj9cBzodPK5gV9wmiWIdtSjueBW9Sffjg6CVnEoZaZE45kCzURuQ==
X-Received: by 2002:a05:6e02:190f:: with SMTP id w15mr6249809ilu.56.1637345673435;
        Fri, 19 Nov 2021 10:14:33 -0800 (PST)
Received: from john.lan ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id d2sm374505ilg.77.2021.11.19.10.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 10:14:32 -0800 (PST)
From:   John Fastabend <john.fastabend@gmail.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        andrii@kernel.org
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf 0/2] sockmap fix for test_map failure 
Date:   Fri, 19 Nov 2021 10:14:16 -0800
Message-Id: <20211119181418.353932-1-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CI test_map runs started failing because of a regression in the
sockmap tests. The case, caught by test_maps is that progs attached
to sockets are not detatched currently when sockets are removed
from a map. We resolve this in two patches. The first patch
fixes a subtle issue found from code review and the second
patch addresses the reported CI issue. This was recently introduced
by a race fix, see patches for details.

Sorry for the hassle here, seems we missed ./test_maps run before
pushing the offending patch or maybe we just got lucky on the
run we did locally. Either way should be resolved now.

Thanks,
John

John Fastabend (2):
  bpf, sockmap: Attach map progs to psock early for feature probes
  bpf, sockmap: Re-evaluate proto ops when psock is removed from sockmap

 net/core/skmsg.c    |  5 +++++
 net/core/sock_map.c | 15 ++++++++++-----
 2 files changed, 15 insertions(+), 5 deletions(-)

-- 
2.33.0

