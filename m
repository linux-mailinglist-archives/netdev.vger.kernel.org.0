Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9F9C3198
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 12:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730506AbfJAKhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 06:37:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53764 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729317AbfJAKhG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 06:37:06 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 390CDC0568FA
        for <netdev@vger.kernel.org>; Tue,  1 Oct 2019 10:37:06 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id i15so5790619wrx.12
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 03:37:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Gw6fS6qs6xklg9gG3B7PfRO8rd55yA986XHOBvBZJ0g=;
        b=bzNrtsj9+OoVTXJ3laPjiedi5nWiIogssSkaG4dh361gsp9r1bwMUOTqlpQ4Z+GyxK
         oro0MrHMl38liNy+Jlr69rHhPE4Mw/WdKXUjpf8wcrmcjuRSZY6CNkYNYGbEA1S6PaYy
         Rod2S1ULFY5LpD3EhZJE3st9RwGdeUAjaDhYZ6DzvVL2TWJy5djj56k5V+74JFks1Gmr
         rqmQSf6mdv9sWVTycmXmcgfzmzqykChi/+imfxm4rWyq8ZIMCfcgj9sscB7kagCGzn1U
         N7aWBjHp2h/zjOBmlOhYdKZLywhJBPRjwJ+yuNut+hqFRjo8H8glEY9iBnMTh9gl46cJ
         Inrw==
X-Gm-Message-State: APjAAAWE+Rapj1D9MQCCPgQfejqXNepqIvK+NLLtAteRjDbTZKpUXFGX
        xxaWsBXtPz826IFY8m3txiD+MQX7/SaROjOsuWg/4T1rebNoyECItyOikKZAImxL3e80C5K5ZrZ
        b8arOLMxIHh/GcpwP
X-Received: by 2002:adf:e5c2:: with SMTP id a2mr18321455wrn.320.1569926224933;
        Tue, 01 Oct 2019 03:37:04 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxZ8+nGDkWc8JcPHvQ/ZUMqEJeVYrkGrpI/filpRcmGKFiHmv2QmqyS01NlVBMgGrj88gGXDA==
X-Received: by 2002:adf:e5c2:: with SMTP id a2mr18321436wrn.320.1569926224710;
        Tue, 01 Oct 2019 03:37:04 -0700 (PDT)
Received: from mcroce-redhat (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id z125sm4342578wme.37.2019.10.01.03.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 03:37:04 -0700 (PDT)
Date:   Tue, 1 Oct 2019 12:37:00 +0200
From:   Matteo Croce <mcroce@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        ilias.apalodimas@linaro.org, brouer@redhat.com
Subject: Re: [RFC 3/4] net: mvneta: add basic XDP support
Message-ID: <20191001123700.5d1fa185@mcroce-redhat>
In-Reply-To: <5119bf5e9c33205196cf0e8b6dc7cf0d69a7e6e9.1569920973.git.lorenzo@kernel.org>
References: <cover.1569920973.git.lorenzo@kernel.org>
        <5119bf5e9c33205196cf0e8b6dc7cf0d69a7e6e9.1569920973.git.lorenzo@kernel.org>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  1 Oct 2019 11:24:43 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> +static int mvneta_xdp_setup(struct net_device *dev, struct bpf_prog
> *prog,
> +			    struct netlink_ext_ack *extack)
> +{
> +	struct mvneta_port *pp = netdev_priv(dev);
> +	struct bpf_prog *old_prog;
> +
> +	if (prog && dev->mtu > MVNETA_MAX_RX_BUF_SIZE) {
> +		NL_SET_ERR_MSG_MOD(extack, "Jumbo frames not
> supported on XDP");
> +		return -EOPNOTSUPP;

-ENOTSUPP maybe?

> +	}
> +
> +	mvneta_stop(dev);

only stop and restart if already running

> +
> +	old_prog = xchg(&pp->xdp_prog, prog);
> +	if (old_prog)
> +		bpf_prog_put(old_prog);
> +
> +	mvneta_open(dev);

^^

-- 
Matteo Croce
per aspera ad upstream
