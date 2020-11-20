Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCFB22BB9C6
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbgKTXO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:14:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbgKTXO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 18:14:27 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B5DC0613CF;
        Fri, 20 Nov 2020 15:14:26 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id 10so12579127wml.2;
        Fri, 20 Nov 2020 15:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YofW6+TgUtx+VfdJJUajA6JkPCwEQsNSPv+zs7re168=;
        b=a/Q7I7Bsy94pgqxGzvDJGspfCA0a1lkllUYelYzguI1VYCaelDnp8VzvbJQlKb6JCw
         FxxW8BtVb+D5dpOT38+CVw0/oVRCSXxaj7j3YB/q5g3qo89KBuwuV/kLRSIFRXB0X9lZ
         sLUBEDKn1WZ9JiduKgtd7tgYw+kr4eQmLDWFZ9+skzc+vEdLgBYiBvhew7yLw+RBWkeD
         FQYkCgEMIZ0OOyAqt9+EMGS/lcpFANl97uHGpWia46291DV4bdpL80SHKymSyi966vQC
         qUr3Xjb4S31ko4tAkSo10axSUEwmk41SmLDjzGYmXsYcvVMWlPnjzQbJhPy7V3bPSZ4s
         DXIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YofW6+TgUtx+VfdJJUajA6JkPCwEQsNSPv+zs7re168=;
        b=ZCSCh6gnNfeZUiyaEqq7GMEy6AaFYaeVdQ14XJ7oSPbwQupuJMoRMEb8DTDfortj+W
         nXUbw7v2aYJmy91VrdOVWsgRI/oyT3lsFdElE1jDYxYQUB8wcI5eRqvDEPoXGwj240Ne
         Znd4Ccm4g2L5xZCKA4Q+z6W98qSz0P7lh+IDMl/XhETguiBn5IJxC/OwpTAbiOtXaCz9
         /AuHEOGvp99snY1H7h/JzmEalweXVEhp6k1fMyAPB3V7FyedQ3n0JwZqAUkubADi/JhK
         4ryOKvCAkMvjoDXTiH3bkzgpYGlpP+DqZ+KaHN+gKjHZngimI8lWXMdM7GxaIz4zQDDS
         cENg==
X-Gm-Message-State: AOAM532Y7zrZ6x/HckDQLpL+Tg6ejoers5LMiuk9OFhDbewTqV9fFrao
        UaHqg/H9emSJ1nwlJlJk78Y=
X-Google-Smtp-Source: ABdhPJytvSp5D+9Yj5HVyHMDOMtLNevnT339vTvkQlRUs6X8LsUnA8U7+qMiarQLGxdwUDCl2VHt9A==
X-Received: by 2002:a1c:9cc9:: with SMTP id f192mr12464800wme.143.1605914064802;
        Fri, 20 Nov 2020 15:14:24 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id 17sm39815529wma.3.2020.11.20.15.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 15:14:24 -0800 (PST)
Date:   Sat, 21 Nov 2020 01:14:22 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 07/12] net: dsa: microchip: ksz9477: add
 Posix clock support for chip PTP clock
Message-ID: <20201120231422.xtvhxcw7zfntx5q2@skbuf>
References: <20201118203013.5077-1-ceggers@arri.de>
 <20201118203013.5077-8-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118203013.5077-8-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 09:30:08PM +0100, Christian Eggers wrote:
> Implement routines (adjfine, adjtime, gettime and settime) for
> manipulating the chip's PTP clock.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
