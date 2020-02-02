Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B332514FF84
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 23:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgBBWIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 17:08:46 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43916 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbgBBWIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 17:08:46 -0500
Received: by mail-pf1-f196.google.com with SMTP id s1so6492907pfh.10;
        Sun, 02 Feb 2020 14:08:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to;
        bh=ysAyY0+DVCOS8g/ck4jYLTSjQn9KeBmlhbMhIvWcg0A=;
        b=fxF9+j5QIWO8mTPa+ktoydLNApLIObVdOzHteDPtgSdpkTM90F2eV8fnQx9c4Mj+XT
         Xv6ar4KTY8RMFY4J6RjiMX7hAdlmRThU9ixtcuc/D3UA9YvoT6wYWOLR+NSK7WGJ/Apr
         sdkZZzJCaP/ZqR6ncBjQ2TB/wYV6WGhfGTVJcdPrZPwF9Co1X12F7g8H928+Egd80zef
         p2YfdlKfLVBhMOEG18MIRhg5ANrtwmI6ueVuJSvKLQ5gT3jpiZph2y17Hmb+ejROnJ4c
         mcLBSQgTqaIGcTStxthnXigCqzCfOO9KjgDYSOTKTp2xjPL6Yelcm3ATMvCXCCAPSDtg
         g6lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to;
        bh=ysAyY0+DVCOS8g/ck4jYLTSjQn9KeBmlhbMhIvWcg0A=;
        b=IkAViiL2rShULjtfXjd+zQTChoKoa9sPEZxDGIU3B++0P1M3kmaQ4m7AwRAoG/c9OV
         xwXNh0hLs38WMfLqAK2miXL4uhNia92d8XEXAyqV5OkVY+a3QpqVAxQVXmN26dnTzyZs
         i4eF85ohhRAQOpPU8ysh82Uh3IDCDl6hwPQKWrRWAYZIWunu/mCZtsnJOeppvN6m5SmZ
         ECvlUiG4Q7cnUZnJHgsPSfjDrmunRk/0e6GOPBm0PLN6eN55++ZRr7PijU4sQUHkjVNn
         bHMJSaXnk+Y+csgK/2daQlo+9dYMI8AgDTEoC2zHfUacLQXzIHq2djqCFeIHA9bUXzGX
         T+Tw==
X-Gm-Message-State: APjAAAXeraFBzFikfHxN+m6SeJh5D+Pbokx+LxFjLzCKlkaoiYHh9Rsq
        h3PsjIUCV5napWj+LvaLg1M=
X-Google-Smtp-Source: APXvYqxrAUfKej9MCl3CQ8Muv6ccpPAoBMQ2hfsDy/2yKiD7WyMzsBEKNBrkdE1p0fhbnyhnRMthtA==
X-Received: by 2002:aa7:9aa7:: with SMTP id x7mr20796924pfi.78.1580681325917;
        Sun, 02 Feb 2020 14:08:45 -0800 (PST)
Received: from localhost.localdomain ([61.81.192.82])
        by smtp.gmail.com with ESMTPSA id fh24sm17568184pjb.24.2020.02.02.14.08.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Feb 2020 14:08:44 -0800 (PST)
From:   SeongJae Park <sj38.park@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     sj38.park@gmail.com, edumazet@google.com, David.Laight@aculab.com,
        aams@amazon.com, davem@davemloft.net, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, ncardwell@google.com,
        shuah@kernel.org, sjpark@amazon.de
Subject: Re: Re: [PATCH v3 0/2] Fix reconnection latency caused by FIN/ACK handling race
Date:   Sun,  2 Feb 2020 23:08:34 +0100
Message-Id: <20200202220834.25728-1-sj38.park@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200202134652.0e89ce89@cakuba.hsd1.ca.comcast.net> (raw)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2 Feb 2020 13:46:52 -0800 Jakub Kicinski <kuba@kernel.org> wrote:

> On Sun,  2 Feb 2020 03:38:25 +0000, sj38.park@gmail.com wrote:
> > The first patch fixes the problem by adjusting the first resend delay of
> > the SYN in the case.  The second one adds a user space test to reproduce
> > this problem.
> > 
> > The patches are based on the v5.5.  You can also clone the complete git
> > tree:
> > 
> >     $ git clone git://github.com/sjp38/linux -b patches/finack_lat/v3
> > 
> > The web is also available:
> > https://github.com/sjp38/linux/tree/patches/finack_lat/v3
> 
> Applied to net, thank you!
> 
> In the future there is no need to duplicate the info from commit
> messages in the cover letter.

Thank you for let me know that.  I will not duplicate from next time!


Thanks,
SeongJae Park
