Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A438B1FD7CC
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 23:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbgFQVpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 17:45:21 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:36732 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbgFQVpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 17:45:21 -0400
Received: by mail-il1-f195.google.com with SMTP id a13so3844722ilh.3;
        Wed, 17 Jun 2020 14:45:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BjlvMBzIShcaQWGwkxItv+d8i6VW4N+SZUqHAYVlP6c=;
        b=icg8bqXT3GZfqczOBTTP/AhCkJ00b3/DRtVKtGZ6K9SgwZZRxrqcqtwkvCfLjir4ga
         WYd1N8VkNl7cf+7ZLV7djMYE5pfhg3hjhQMFJImkQGcWs4pYBHIEJeILJ0W7SfHJNkKz
         wQWo0V3LTZ+rSq+b+U4oMBPbI9weuqF0JCDE9lJpeuKfXJ3ei6qk+fDE4vo8pE53Kf+i
         +f7TK38/vUJAdT2GfSNhAFyiBFnO2JuAXhAxFB+1SxVodVuNsSJnBm2T1x65NgIeQcca
         1tuz69EgskuYsChZ9k7A8ofFvB/GWg+cveKHgSx5FpEvNB1qAEdtC2jyXHaAy5bC9B5d
         T8lg==
X-Gm-Message-State: AOAM531bQDU4fqw0IX5Avhjehi5JaXFMfgIAcd5L9V0zX1j68G5dXT61
        cUlAnaQPNErbv03oowxapw==
X-Google-Smtp-Source: ABdhPJyvZVvGEx/9dKdHyeObJsISCkDue5qqG3CloGJl6BqE//sfd8r9FcJk5NTDFBcfxE/37cgxUg==
X-Received: by 2002:a05:6e02:1212:: with SMTP id a18mr889632ilq.159.1592430320379;
        Wed, 17 Jun 2020 14:45:20 -0700 (PDT)
Received: from xps15 ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id l26sm468583ild.59.2020.06.17.14.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 14:45:19 -0700 (PDT)
Received: (nullmailer pid 2881862 invoked by uid 1000);
        Wed, 17 Jun 2020 21:45:18 -0000
Date:   Wed, 17 Jun 2020 15:45:18 -0600
From:   Rob Herring <robh@kernel.org>
To:     Heiko Stuebner <heiko@sntech.de>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        christoph.muellner@theobroma-systems.com,
        Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
Subject: Re: [PATCH v2 2/2] net: phy: mscc: handle the clkout control on some
 phy variants
Message-ID: <20200617214518.GA2870745@bogus>
References: <20200609133140.1421109-1-heiko@sntech.de>
 <20200609133140.1421109-2-heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609133140.1421109-2-heiko@sntech.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 09, 2020 at 03:31:40PM +0200, Heiko Stuebner wrote:
> From: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
> 
> At least VSC8530/8531/8540/8541 contain a clock output that can emit
> a predefined rate of 25, 50 or 125MHz.
> 
> This may then feed back into the network interface as source clock.
> So follow the example the at803x already set and introduce a
> vsc8531,clk-out-frequency property to set that output.
> 
> Signed-off-by: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
> ---
> Hi Andrew,
> 
> I didn't change the property yet, do you have a suggestion on
> how to name it though? Going by the other examples in the
> ethernet-phy.yamls, something like enet-phy-clock-out-frequency ?

The correct thing to do here is make the phy a clock provider and then 
the client side use 'assigned-clock-rate' to set the rate. That has the 
advantage that it also describes the connection of the clock signal. You 
might not need that for a simple case, but I could imagine needing that 
in a more complex case.

Rob
