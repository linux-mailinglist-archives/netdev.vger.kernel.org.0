Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E610526C90A
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 21:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgIPTCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 15:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727521AbgIPRss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 13:48:48 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34AEC0A54D7
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 05:25:56 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id i26so10020833ejb.12
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 05:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AZpremIIx4eu/qcxDqCyM1sUWJTrYOhobHvXL9nMHmE=;
        b=Akq7gGIzX/DGB7ZywdV7xmEXZliggBNisa+hrSLfQU5W0x/4u19WzfiJt7eqfgqiGs
         BQnM/aGTFtCKrGPSxBhkN8AnCqMebkctB4VneBYWkhUuqD/VDOqqxsrX5ljXBg0VvZAC
         NxgIyM/X89sIt1gV3S3XUTkWwMC6Im8e/jNXclEyQ1gyMAoUCR42Ufrgcl6iB96h53Bs
         JCW32WCk5Zo2h1R+TJkmEGDh3gtbfDIsWRhR2Oayji1qa6UvNfQa/tJSZQ7beulaJccx
         P3d7jNWZN0HzA7LbG77i13wFBaPaXP12m6OFWUL0TKEtCtN+3uZX+4gLop7KruVbyUtK
         rxNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AZpremIIx4eu/qcxDqCyM1sUWJTrYOhobHvXL9nMHmE=;
        b=uOSz2sAcIalJw7FMG2/OiDLh0yY1bYLiVPbHe7nHhb3xO+A8o037pZ06SECNSGBJmg
         AIZaFF/VNA3uQH/T5DfdPIcvulfpWdTfiRKU83sVKPEOgcsFNI2XlYDaizmNAFtL0uvA
         CsjqYT0Cp9QoLdgnLJ2ZH4EIfHssSaUPcIVcfOjX9cjbFefnqBejOR3K1OWzfgIEttCt
         tx3E5zGsq2I27e2FNiwZH7hLMsMFXi2xa90Ujb8uVgfDvS58qNNhuPfigaxuXFq4zkrH
         fdAlfxx08uCNe2SAK086wbgo3/jcaT1CHon3yk3W4WXnA1WSxil4odcT5sX/ucfgwg00
         ic6g==
X-Gm-Message-State: AOAM533WVANIlefr4jRREVrXA8WP0Ngpe9q7HTTLD5lKz+U4wMDQ2beU
        I2Mpbqt81xY9sgy84q4ZdQotqkZuM3I=
X-Google-Smtp-Source: ABdhPJyBULU9wpKF7p5bRpdjRakGfr35vDbAfo/AfA7r/6xkOImwTcnJQ0A0FXTJaYJagxRtOCwI6w==
X-Received: by 2002:a17:906:c1d4:: with SMTP id bw20mr16317538ejb.91.1600259155411;
        Wed, 16 Sep 2020 05:25:55 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id a15sm12253490eje.16.2020.09.16.05.25.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 05:25:54 -0700 (PDT)
Date:   Wed, 16 Sep 2020 15:25:52 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, UNGLinuxDriver@microchip.com,
        claudiu.manoil@nxp.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org
Subject: Re: [PATCH net 2/7] net: mscc: ocelot: add locking for the port TX
 timestamp ID
Message-ID: <20200916122552.alrwgbp3zulkffyf@skbuf>
References: <20200915182229.69529-1-olteanv@gmail.com>
 <20200915182229.69529-3-olteanv@gmail.com>
 <20200916111204.GJ9675@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916111204.GJ9675@piout.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 01:12:04PM +0200, Alexandre Belloni wrote:
> > +	for (port = 0; port < ocelot->num_phys_ports; port++) {
> > +		struct ocelot_port *ocelot_port = ocelot->ports[port];
> > +
> 
> At this point, ocelot_port is NULL because ocelot_init is called before
> the port structures are allocated in mscc_ocelot_probe

Yikes, you're right, thanks for testing!

-Vladimir
