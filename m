Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 056A5320A1
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 22:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfFAT5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 15:57:21 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45428 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbfFAT5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 15:57:21 -0400
Received: by mail-pg1-f193.google.com with SMTP id w34so5918087pga.12
        for <netdev@vger.kernel.org>; Sat, 01 Jun 2019 12:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=mBZdUwSQkDtWzFBtcZkocSyOlUl6jNkzYzp3ccE75f8=;
        b=SLjA3RkEcAfHsZVCLKgAASHSuvfaApsLmqi/K/Upc/LxX4PESdUYqD9A4hLKEXMrnu
         ibCA5VKURPEVtYaBbQTPY9bTMqZHX3Z6cMYwsEl4eOrxpZfXNhHQ7sY+p/cdxqd5WBPZ
         r8Fk9FT7HUapWaRVWUfc+bskuxafrUy5w5u32KhU+OuT2PSzMPZ8kNA5YNfcbSF8E+Yk
         s1nLbvrt1tt7aN/+zNPb0CB4f0gsWBQsvOKd7QSv+eAOAVps/2D+payeJAtKjhHpGT5n
         dVPm44b0d/ciRfSjZwR62SMMBE7WtzvgRYjx7dLmI3f65iWfZ7ybYp0XykToTvDA0rmZ
         wlZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=mBZdUwSQkDtWzFBtcZkocSyOlUl6jNkzYzp3ccE75f8=;
        b=bKx92ttvzl77DLOIpPuLGhI0dVY/kmFhZPoD+hEvg6wRRlcUfJo/yqoogc60W6h2js
         nZ39S/NMOFer4H0CPPLmII338V3eZXweoA5pwZ+vbgrb3qe6xa4KPcJOsOZX8H/ccOsl
         TQslWTYuy5eOl0kbc0daiTwzADGqwzz3i+sftBBjUD+RlqmUOVbROcyyp00pdQshTVUs
         fcYihOTGJWxSWh2dsd07vrvG5lCjMzjWm/6qGB5DIZSbtac8kwrszit7vqD/ERB6cg8n
         pe2c7LdnJyztZnB0AIAqgHpOSDU6AE8AbL2mKifogHd9xLs+qLVnWYy7tsFhAWAkLZmu
         37eQ==
X-Gm-Message-State: APjAAAWORpoBU4w7IGgNcg72jp9X8vi75gtRdisaOsuxZr3U+1GhNNqI
        VOzYq2vSmwvdSQJO50X5idyG3w==
X-Google-Smtp-Source: APXvYqy4cidyAgIIOWcCz7cnQ1dUZ6RNPS6OW+NrdUK+6XFs33gJh17gkgmg5gLrSsnK2JcTKtqM4g==
X-Received: by 2002:a62:585:: with SMTP id 127mr19163831pff.231.1559419040538;
        Sat, 01 Jun 2019 12:57:20 -0700 (PDT)
Received: from cakuba.netronome.com ([2601:646:8e00:e50::3])
        by smtp.gmail.com with ESMTPSA id y7sm18398713pge.89.2019.06.01.12.57.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 01 Jun 2019 12:57:20 -0700 (PDT)
Date:   Sat, 1 Jun 2019 12:57:17 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "toke@redhat.com" <toke@redhat.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bjorn.topel@gmail.com" <bjorn.topel@gmail.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 1/2] net: xdp: refactor XDP_QUERY_PROG{,_HW}
 to netdev
Message-ID: <20190601125717.28982f35@cakuba.netronome.com>
In-Reply-To: <b0a9c3b198bdefd145c34e52aa89d33aa502aaf5.camel@mellanox.com>
References: <20190531094215.3729-1-bjorn.topel@gmail.com>
        <20190531094215.3729-2-bjorn.topel@gmail.com>
        <b0a9c3b198bdefd145c34e52aa89d33aa502aaf5.camel@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 May 2019 19:18:17 +0000, Saeed Mahameed wrote:
> > +	if (!bpf_op || flags & XDP_FLAGS_SKB_MODE)
> > +		mode = XDP_FLAGS_SKB_MODE;
> > +
> > +	curr_mode = dev_xdp_current_mode(dev);
> > +
> > +	if (!offload && curr_mode && (mode ^ curr_mode) &
> > +	    (XDP_FLAGS_DRV_MODE | XDP_FLAGS_SKB_MODE)) {  
> 
> if i am reading this correctly this is equivalent to :
> 
> if (!offload && (curre_mode != mode)) 
> offlad is false then curr_mode and mode must be DRV or GENERIC .. 

Naw, if curr_mode is not set, i.e. nothing installed now, we don't care
about the diff.

> better if you keep bitwise operations for actual bitmasks, mode and
> curr_mode are not bitmask, they can hold one value each .. according to
> your logic.. 

Well, they hold one bit each, whether one bit is a bitmap perhaps is
disputable? :)

I think the logic is fine.

What happened to my request to move the change in behaviour for
disabling to a separate patch, tho, Bjorn? :)
