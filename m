Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA574D8789
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 15:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241525AbiCNPAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 11:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232280AbiCNPAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 11:00:08 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280CA3C73B;
        Mon, 14 Mar 2022 07:58:58 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id d10so34591186eje.10;
        Mon, 14 Mar 2022 07:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OYV4LpH4D3agxsG3V7VyzstSf+lDz7EM5vQa2UkEP7w=;
        b=MOiHh0CsD3q+iNPxoPSXwT3iZzcB0ZcSFhKkrzBOMCkYSu7aKHbORB3emZtHnfBxYu
         v3dtH3qbNNm3Vi2nNIdfDrruOItemfOdVViSojC3sXZBM1YHKxbEtvfbb13NoFonpDil
         IMh6xGHEWuHI6yHyAYaLWJkI7K9IMXYWhHoYorlQAxEoMYom6ad0diEKR+HMICp5/tEX
         SP3kbCzP1qFzW5bV2gCgiYpimaqSn+c0SXq0O5OG3Pn4HJErrjdswwuRLYvwS0X1z5bL
         EajKTJDzTYBnw5lZVuhQzYCm25RotqH7PSMdw/AryMk6NHNJaUvcvC/z1eXwAlUn3UGi
         JdKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OYV4LpH4D3agxsG3V7VyzstSf+lDz7EM5vQa2UkEP7w=;
        b=swIuAx7KOFv/+ED1jBOiCK8IO/0Mf0xjOveXMJGo1CdMBm2ZXyyFGUAJ5XYXLc+nrf
         kBnU6UC4dA8pKFYAqTCA2jliXZE4dB2eHBH3j7Uch3guNtkPJ9jtjmo1VdcpkkRrNK86
         KsExMbWWI7unzS8XgRftVmu0Zbf0ERnywLaSGut1TuaNxfEeRCywaUVATq7gajIlILFI
         35kkgI8f9SGlNhyg5OzTD+nPTpPa67OllKj3oMB0xkvrGGW+sb79InwqR9mLCzwS4Yrp
         /vbmMPf+8adp8BSYNn/AsvEaqDXIS/7G6DtPfeu7jGldXeTJG1eTfJA9+z7N7QyjSJ01
         37cQ==
X-Gm-Message-State: AOAM531kHk+LSLgLco9oXACCrWb+GJhCwHgCfZYbKasGmQmsZHoMiuyS
        wvzW81DhCFDB2KQ7iMSC+AU=
X-Google-Smtp-Source: ABdhPJwEXXJr7N8/UGnBPerXHkgdsTRUxrmYmjgrx1ZKylhRSvtZpmHi617uiUE4yKGd6/6FaDkQcw==
X-Received: by 2002:a17:907:2cc6:b0:6db:7e92:e36 with SMTP id hg6-20020a1709072cc600b006db7e920e36mr18090693ejc.329.1647269936492;
        Mon, 14 Mar 2022 07:58:56 -0700 (PDT)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id a1-20020aa7d901000000b00416217c99bcsm8157560edr.65.2022.03.14.07.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 07:58:56 -0700 (PDT)
Date:   Mon, 14 Mar 2022 16:58:54 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Cooper Lees <me@cooperlees.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH v3 net-next 03/14] net: bridge: mst: Support setting and
 reporting MST port states
Message-ID: <20220314145854.shtnvetounjfnu4e@skbuf>
References: <20220314095231.3486931-1-tobias@waldekranz.com>
 <20220314095231.3486931-4-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314095231.3486931-4-tobias@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 10:52:20AM +0100, Tobias Waldekranz wrote:
> +int br_mst_fill_info(struct sk_buff *skb, struct net_bridge_vlan_group *vg)
> +{
> +	struct net_bridge_vlan *v;
> +	struct nlattr *nest;
> +	unsigned long *seen;
> +	int err = 0;
> +
> +	seen = bitmap_zalloc(VLAN_N_VID, 0);

I see there is precedent in the bridge driver for using dynamic
allocation as opposed to on-stack declaration using DECLARE_BITMAP().
I imagine this isn't just to be "heapsters", but why?

I don't have a very good sense of how much on-stack memory is too much
(a lot probably depends on the expected depth of the call stack too, and here it
doesn't appear to be too deep), but I see that mlxsw_sp_bridge_vxlan_vlan_is_valid()
has a DECLARE_BITMAP(vlans, VLAN_N_VID) too.

The comment applies for callers of br_mst_get_info() too.

> +	if (!seen)
> +		return -ENOMEM;
> +
> +	list_for_each_entry(v, &vg->vlan_list, vlist) {
> +		if (test_bit(v->brvlan->msti, seen))
> +			continue;
> +
> +		nest = nla_nest_start_noflag(skb, IFLA_BRIDGE_MST_ENTRY);
> +		if (!nest ||
> +		    nla_put_u16(skb, IFLA_BRIDGE_MST_ENTRY_MSTI, v->brvlan->msti) ||
> +		    nla_put_u8(skb, IFLA_BRIDGE_MST_ENTRY_STATE, v->state)) {
> +			err = -EMSGSIZE;
> +			break;
> +		}
> +		nla_nest_end(skb, nest);
> +
> +		set_bit(v->brvlan->msti, seen);
> +	}
> +
> +	kfree(seen);
> +	return err;
> +}
