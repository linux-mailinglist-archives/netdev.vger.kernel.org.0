Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92F33537706
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 10:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233972AbiE3ItQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 04:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231640AbiE3ItP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 04:49:15 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9E672219;
        Mon, 30 May 2022 01:49:13 -0700 (PDT)
Date:   Mon, 30 May 2022 10:49:08 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1653900550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Mb32qARmKX/oF5s+kHIv0X9LwS5Vfd7eo5GK1onxbS4=;
        b=oKod/4yDEBaJi9iSKiGnIgGVyCp8e+d2eVwVdzte+6E86zRPZJb6uEjvY9/CW55BhnnY43
        ebGZ+E6AvYiBDeczcq+JHuFv1HT/m6EUhkoQLyx7NvTZQEIvJydHNpHBSZnzpfeZS4/A/7
        WGOHtJFe9NMPJhsqGcfjxAiHHCgjBuhNBBwbV+/kN1yItnFW2+10TbUX85HAvObQVcfwy3
        Z/TJ45JrIoDnh3p6gb7cbvNUxJHf5ULSF687VCmIIUyqaT3WK72dn/WdaL3xTiQEswmrnn
        nOA8I3nPJmVo1oAkxzrvDFAlPJUQE6RQrsz0po9ChI7ybB+ptjNpn/bXqyZHyA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1653900550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Mb32qARmKX/oF5s+kHIv0X9LwS5Vfd7eo5GK1onxbS4=;
        b=fn7UBgTUB18eEO+ZPOF0lTcnEkE+cEHthbTzQs24jteMlG7VDojMV7jKwiMO1pIQklIDh2
        MZUM5BfSfn06/zCA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        John Stultz <jstultz@google.com>,
        Nathan Chancellor <nathan@kernel.org>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/9] deferred_probe_timeout logic clean up
Message-ID: <YpSFBNfGDpy3rqEV@linutronix.de>
References: <20220526081550.1089805-1-saravanak@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220526081550.1089805-1-saravanak@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-05-26 01:15:39 [-0700], Saravana Kannan wrote:
> Yoshihiro/Geert,
Hi Saravana,

> If you can test this patch series and confirm that the NFS root case
> works, I'd really appreciate that.

The two patches you sent earlier, plus this series, plus

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 7ff7fbb006431..829d9b1f7403f 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1697,8 +1697,6 @@ static int fw_devlink_may_probe(struct device *dev, void *data)
  */
 void __init fw_devlink_unblock_may_probe(void)
 {
-	struct device_link *link, *ln;
-
 	if (!fw_devlink_flags || fw_devlink_is_permissive())
 		return;
 
and it compiles + boots without a delay.

Sebastian
