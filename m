Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C68343EA0
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 11:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbhCVK6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 06:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbhCVK5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 06:57:37 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EEF1C061574
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 03:57:35 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id w203-20020a1c49d40000b029010c706d0642so10973227wma.0
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 03:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=niiUxt0KIkjWin3P3XXgucfv8lYlH/+ZZqgRF9I2SG4=;
        b=PhMBO6GLrsNrbXNZ09keZylMp1d26F2yvqMUBiF4jLS+2m7aO/JL0RCaW44kCfeSzI
         MFvfDMG8srvXMokQl4Z3z9mQK3uaHQ8n+EWXJfoqatsHq6nII08kOh5CoTcrlmixhO0s
         dNO2B9WGzyjoaC9BBZ1e0IpMmWwxU2YkPkcP+lRoyqJU2zum82L1TDTGIscWTfJcqJkw
         e39KwWYqYPm37IM1nb+8w5MKdyWqcJjHS9O6QKiMrsO5vN5kgqkLXpLDDAK3xHveiQNK
         h/FcX5VndeKqaT6a/+9hlJzvCh4FHIuw1lqGPfzpEK/n4qagCbHjNApOtOeZRtrJxQkF
         oynw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=niiUxt0KIkjWin3P3XXgucfv8lYlH/+ZZqgRF9I2SG4=;
        b=IG0gnxnvQ5wdLhUcYS0GqlyuT0tbQ2VS1IfFkYJKaRIVzFmoJF8K9yHT0R+KpRlQeH
         +1R1fV0iMPO1UIt49SvHYJfMop4NESLuziSfdam7ZeSKGqUtxgaVU9xvYD+vrDoWmTxA
         VvpY50+aT3fgfE1kOaQ5GAjpbDyj7OMELS1r8XYtoX1SjQHxBbeUgxhQSM3PRRYy2Fq+
         QMFlKmk4ZCFDCmEPtv3Bgvjb2HtxTWKIQK9tSKiKHWFv9ERgOXjAqwkounone+OMvmBs
         DZkQp3zzCy5lWgJR7UaJFAO1YGHlpRr74mK/iY2da7todonIYGfbuODQkfoLUgh7mgqN
         fEZw==
X-Gm-Message-State: AOAM532g+2YRZYwCi+jDhzX35i/1IGdn/mpHMZZiztP3HWSMxBr79/8h
        at2s/ji+6IDPsSn2r0sCTMU=
X-Google-Smtp-Source: ABdhPJzzpOo9NK5vAun5S3IZ2XoqyxJ4yKkcnsFtP3vpTqYy2mvKkXT2clJIgFdRfoN+pQnzZ+tROg==
X-Received: by 2002:a1c:bc82:: with SMTP id m124mr15417462wmf.118.1616410654321;
        Mon, 22 Mar 2021 03:57:34 -0700 (PDT)
Received: from hthiery.fritz.box (ip1f1322f8.dynamic.kabel-deutschland.de. [31.19.34.248])
        by smtp.gmail.com with ESMTPSA id x11sm18276951wme.9.2021.03.22.03.57.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 03:57:34 -0700 (PDT)
From:   Heiko Thiery <heiko.thiery@gmail.com>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org, vivien.didelot@gmail.com,
        yoshfuji@linux-ipv6.org, heiko.thiery@gmail.com, michael@walle.cc
Subject: Re: [PATCH net-next] net: ipconfig: avoid use-after-free in ic_close_devs
Date:   Mon, 22 Mar 2021 11:57:33 +0100
Message-Id: <20210322105733.20080-1-heiko.thiery@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210210235703.1882205-1-olteanv@gmail.com>
References: <20210210235703.1882205-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir and all,

> Due to the fact that ic_dev->dev is kept open in ic_close_dev, I had
> thought that ic_dev will not be freed either. But that is not the case,
> but instead "everybody dies" when ipconfig cleans up, and just the
> net_device behind ic_dev->dev remains allocated but not ic_dev itself.
> 
> This is a problem because in ic_close_devs, for every net device that
> we're about to close, we compare it against the list of lower interfaces
> of ic_dev, to figure out whether we should close it or not. But since
> ic_dev itself is subject to freeing, this means that at some point in
> the middle of the list of ipconfig interfaces, ic_dev will have been
> freed, and we would be still attempting to iterate through its list of
> lower interfaces while checking whether to bring down the remaining
> ipconfig interfaces.
> 
> There are multiple ways to avoid the use-after-free: we could delay
> freeing ic_dev until the very end (outside the while loop). Or an even
> simpler one: we can observe that we don't need ic_dev when iterating
> through its lowers, only ic_dev->dev, structure which isn't ever freed.
> So, by keeping ic_dev->dev in a variable assigned prior to freeing
> ic_dev, we can avoid all use-after-free issues.
> 
> Fixes: 46acf7bdbc72 ("Revert "net: ipv4: handle DSA enabled master network devices"")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/ipv4/ipconfig.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
> index f9ab1fb219ec..47db1bfdaaa0 100644
> --- a/net/ipv4/ipconfig.c
> +++ b/net/ipv4/ipconfig.c
> @@ -309,6 +309,7 @@ static int __init ic_open_devs(void)
>   */
>  static void __init ic_close_devs(void)
>  {
> +	struct net_device *selected_dev = ic_dev->dev;

This will causes a kernel panic when ic_dev is not valid.

See log output here: https://lavalab.kontron.com/scheduler/job/12453

>  	struct ic_device *d, *next;
>  	struct net_device *dev;
>  
> @@ -322,7 +323,7 @@ static void __init ic_close_devs(void)
>  		next = d->next;
>  		dev = d->dev;
>  
> -		netdev_for_each_lower_dev(ic_dev->dev, lower_dev, iter) {
> +		netdev_for_each_lower_dev(selected_dev, lower_dev, iter) {
>  			if (dev == lower_dev) {
>  				bring_down = false;
>  				break;
> -- 
> 2.25.1


I can fix my issue with this:

diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index 47db1bfdaaa0..6f1df4336153 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -309,7 +309,6 @@ static int __init ic_open_devs(void)
  */
 static void __init ic_close_devs(void)
 {
-       struct net_device *selected_dev = ic_dev->dev;
        struct ic_device *d, *next;
        struct net_device *dev;
 
@@ -323,10 +322,13 @@ static void __init ic_close_devs(void)
                next = d->next;
                dev = d->dev;
 
-               netdev_for_each_lower_dev(selected_dev, lower_dev, iter) {
-                       if (dev == lower_dev) {
-                               bring_down = false;
-                               break;
+               if (ic_dev) {
+                       struct net_device *selected_dev = ic_dev->dev;
+                       netdev_for_each_lower_dev(selected_dev, lower_dev, iter) {
+                               if (dev == lower_dev) {
+                                       bring_down = false;
+                                       break;
+                               }
                        }
                }
                if (bring_down) {


What do you think? Is this valid?

Thank you.
-- 
Heiko
