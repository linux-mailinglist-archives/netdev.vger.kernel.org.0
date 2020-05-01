Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A791C1F9A
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 23:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgEAV30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 17:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbgEAV30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 17:29:26 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A096FC061A0C;
        Fri,  1 May 2020 14:29:24 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id l18so2386148wrn.6;
        Fri, 01 May 2020 14:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4f4bMPQkyUA0L6LiuP3k5vua4EzcCGdZDupcmfoK+no=;
        b=li03DvdM5EAObyXVxIa7XwqfoKG03NSXi3fc+pH/x7yY9hg+UcLKXp00cMiKthfuUW
         dAPCWGxIY2TOSzky54boAs05pYUvGLMiMPrJsZrtIhXE4Ro4TDr8Nbbw2d5gcurj+cmy
         fgtqVCjxurEABTSLuJmWPo3b09m4tkjZtGoo9fGlOgSD16ZiUN4d/fQ5PAWfNwshxtNd
         ldW7vhweKccom7bGVFeMq2CijxgY+b72M7YEVDKrYlbdVDvdEioPFyDBYFXDuAl7L7Qb
         E3DfSzyHq3hex3HESaCSQTdk1ottnhs0c2BAI2y/QMxcS6x17Wt2cZY2JUcHhQqgX97h
         7AOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4f4bMPQkyUA0L6LiuP3k5vua4EzcCGdZDupcmfoK+no=;
        b=mU40uB4FuCqLKQXMLdAPgIg1uflBufLhbd4DuceMbLNrV0dFDP+JM05tFHU5HHw8tQ
         bb4dpp30SiGLbwtzZQ6TjuyeUR9PvcQrxqLkfpSQlGc+oebw8fqwp+YosvpZ9OJed9Ss
         YGpItsUOzh+dYMG1/a9FbdwI7UIXtMFAkiIl5xjsZk+HL6tAriF1zN6BQuGr8RvUbEKU
         PD5axojDc7xkbIyKm0adkkwxK+g7+Shj4MD8ZBme6HLWsCGdAEtdglamsUTbanPj/2Kx
         HY8NGQ4o2fXaTat+UGhtv/zMZEY44BRRKMfSOKrR13zQrFZQOleK4Lr7Uv0Mt5voYRZq
         oqxg==
X-Gm-Message-State: AGi0PuZ0VRwxheZ5/64dg+GME7L3NhOyX86Iso/9zG2Vd/HE9ZrfgWjT
        lIEeYu8pxPkLgYzZZZ3TzLfgdGWy
X-Google-Smtp-Source: APiQypKpRYd8NrgZtHbBUnr0rl+vf80BwvtXiPwGmU70Z8nGDifmUvilaBne4nitdAEb1yMUaNW+Sw==
X-Received: by 2002:adf:f609:: with SMTP id t9mr2810063wrp.41.1588368563187;
        Fri, 01 May 2020 14:29:23 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f06:ee00:bcdf:534e:d44f:409? (p200300EA8F06EE00BCDF534ED44F0409.dip0.t-ipconnect.de. [2003:ea:8f06:ee00:bcdf:534e:d44f:409])
        by smtp.googlemail.com with ESMTPSA id d13sm1104293wmb.39.2020.05.01.14.29.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2020 14:29:22 -0700 (PDT)
Subject: [PATCH net-next 1/2] timer: add fsleep for flexible sleeping
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org
References: <8e3c56ca-b43f-3877-0104-a1a279d5a6c5@gmail.com>
Message-ID: <5e3c3f78-344c-ae03-b6ae-ea55e402c1e7@gmail.com>
Date:   Fri, 1 May 2020 23:27:21 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <8e3c56ca-b43f-3877-0104-a1a279d5a6c5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sleeping for a certain amount of time requires use of different
functions, depending on the time period.
Documentation/timers/timers-howto.rst explains when to use which
function, and also checkpatch checks for some potentially
problematic cases.

So let's create a helper that automatically chooses the appropriate
sleep function -> fsleep(), for flexible sleeping

If the delay is a constant, then the compiler should be able to ensure
that the new helper doesn't create overhead. If the delay is not
constant, then the new helper can save some code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 Documentation/timers/timers-howto.rst |  3 +++
 include/linux/delay.h                 | 11 +++++++++++
 2 files changed, 14 insertions(+)

diff --git a/Documentation/timers/timers-howto.rst b/Documentation/timers/timers-howto.rst
index 7e3167bec..afb0a43b8 100644
--- a/Documentation/timers/timers-howto.rst
+++ b/Documentation/timers/timers-howto.rst
@@ -110,3 +110,6 @@ NON-ATOMIC CONTEXT:
 			short, the difference is whether the sleep can be ended
 			early by a signal. In general, just use msleep unless
 			you know you have a need for the interruptible variant.
+
+	FLEXIBLE SLEEPING (any delay, uninterruptible)
+		* Use fsleep
diff --git a/include/linux/delay.h b/include/linux/delay.h
index 8e6828094..cb1d508ca 100644
--- a/include/linux/delay.h
+++ b/include/linux/delay.h
@@ -65,4 +65,15 @@ static inline void ssleep(unsigned int seconds)
 	msleep(seconds * 1000);
 }
 
+/* see Documentation/timers/timers-howto.rst for the thresholds */
+static inline void fsleep(unsigned long usecs)
+{
+	if (usecs <= 10)
+		udelay(usecs);
+	else if (usecs <= 20000)
+		usleep_range(usecs, 2 * usecs);
+	else
+		msleep(DIV_ROUND_UP(usecs, 1000));
+}
+
 #endif /* defined(_LINUX_DELAY_H) */
-- 
2.26.2


