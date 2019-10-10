Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8B43D3063
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 20:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfJJSad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 14:30:33 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39990 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfJJSad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 14:30:33 -0400
Received: by mail-pg1-f193.google.com with SMTP id d26so4194696pgl.7
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 11:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=message-id:mime-version:content-transfer-encoding:in-reply-to
         :references:from:to:cc:subject:user-agent:date;
        bh=ORiOn2ijg214/FB0BTVae4aav3Hv7+fGWBkzNRGr70c=;
        b=ir3wSEP1pelrXWLac9D+DzZayrfPLrb8c1CMg6RIukhApw0o7JAtf0Br+2iuN2IkwF
         CsKFz3HnUdx+BUYkHUzMl3CGqBSvUI4MJYF1kzTXWBdzAJQVKDb2RptEcVDIWj/FW4Wj
         yXmOXv23FsXmfc12xavUzSiL6WctEb9Iyo27E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:mime-version
         :content-transfer-encoding:in-reply-to:references:from:to:cc:subject
         :user-agent:date;
        bh=ORiOn2ijg214/FB0BTVae4aav3Hv7+fGWBkzNRGr70c=;
        b=nh2TpIjruCIRf5wnftCTKjp8iq2A2FupWI7OZkpIz0MPou/KNefSYv4ERr5vBEP9eR
         vsIpShg8uyy1RPLt31WzIQfU5wJMxumeBTJU3xa5p5szXem6tJ48BKGoPB5m6wUicddd
         +/EwyxD7tcs3l6fnuLjNYXLAV3b6gFvkkwlriptk2nPhWqXyIO30xko/OMqyZxhJoICC
         MmzYSuIPKmuik2ozZa6Rbbx/Xn2poh4uws8mi3yFa7ZDGaXLpeq4IyT1WnVnZ4gk9pus
         A/2gWHHe8rTTcEkn/SDlsoEELI9dDfm2CH6TV/KxlKG9nginsJMXm7FgQwOkcUmlz5vm
         4jsA==
X-Gm-Message-State: APjAAAUI4VGNWdEfFCgw3d1vfN9fhHGj8ZGffgu5LuMy6oWyGGyCxQhW
        5ZqVRgaNkM+aGu5jSOrp8BKNpw==
X-Google-Smtp-Source: APXvYqwq/5gCZohNEE4qPNVBMfmMnDuLbHKuu0mov6MOWy4yAGKsDYjltE6oLtKz8XFFiN4Nbye22Q==
X-Received: by 2002:a63:d452:: with SMTP id i18mr12718002pgj.76.1570732230838;
        Thu, 10 Oct 2019 11:30:30 -0700 (PDT)
Received: from chromium.org ([2620:15c:202:1:fa53:7765:582b:82b9])
        by smtp.gmail.com with ESMTPSA id j17sm6238178pfr.70.2019.10.10.11.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 11:30:30 -0700 (PDT)
Message-ID: <5d9f78c6.1c69fb81.e8d13.6c8b@mx.google.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <1570616148-11571-1-git-send-email-Anson.Huang@nxp.com>
References: <1570616148-11571-1-git-send-email-Anson.Huang@nxp.com>
From:   Stephen Boyd <swboyd@chromium.org>
To:     Anson Huang <Anson.Huang@nxp.com>, andy.shevchenko@gmail.com,
        davem@davemloft.net, fugang.duan@nxp.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rafael.j.wysocki@intel.com
Cc:     Linux-imx@nxp.com
Subject: Re: [PATCH 1/2] net: fec_main: Use platform_get_irq_byname_optional() to avoid error message
User-Agent: alot/0.8.1
Date:   Thu, 10 Oct 2019 11:30:29 -0700
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Anson Huang (2019-10-09 03:15:47)
> Failed to get irq using name is NOT fatal as driver will use index
> to get irq instead, use platform_get_irq_byname_optional() instead
> of platform_get_irq_byname() to avoid below error message during
> probe:
>=20
> [    0.819312] fec 30be0000.ethernet: IRQ int0 not found
> [    0.824433] fec 30be0000.ethernet: IRQ int1 not found
> [    0.829539] fec 30be0000.ethernet: IRQ int2 not found
>=20
> Fixes: 7723f4c5ecdb ("driver core: platform: Add an error message to plat=
form_get_irq*()")
> Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
> ---

Reviewed-by: Stephen Boyd <swboyd@chromium.org>

