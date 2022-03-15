Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 340224DA08A
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 17:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350295AbiCOQ4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 12:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235807AbiCOQ4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 12:56:11 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67643193D7;
        Tue, 15 Mar 2022 09:54:59 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id r13so42822226ejd.5;
        Tue, 15 Mar 2022 09:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Qy5CIGpbJUXBMUFax/Gs3JPDrYnJFLZ0SC9FvW5pKqk=;
        b=Zxs5hIHUnMp/4fwLFETPt0dMafEJXaocxaxZgCDCk9TWRRs61CJfUF9bxG8HbgcZ6Q
         e/5TMX7xjIpoR9C/esaQ1wEPeLclV9Vv3ugpyEEzVw7tJORwHM4nNgN98ul0DtddsvCM
         f7eDB5bwAIV27Vvo1y9TcJ/mD9yPRtKGU4QDfR9QIbwSeMho6rGfeOrT9BZ4rnPtieuO
         eWzuiqRoiG05vRmarHaDXofQKhEcU3/qm8cD2KbY6tQicNqFnR/HNnwGmon2CTgC6a6y
         r3ndEiDPdB1dBDwHGjDMLWLyfUHxHIh/afK3GgSRzUCcxaDxUPSzZsIqMwBji3f2qQg1
         k5Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Qy5CIGpbJUXBMUFax/Gs3JPDrYnJFLZ0SC9FvW5pKqk=;
        b=FRbm+Br3lmwFxfH0/6BPrtSLSJf1hjbl8bflKzaglN0R79AE8xXQAuPx72KkamzDMI
         nNjefuYiQYWe+9+vnw9F8NuhCw7WXLIFpmomxzjoeGKCDwLD2WRnzePrQN/JOtOvsns7
         U/WE0MzOLuy/1k3TEMvx8ONLKRWQ1J+W6467mjg8npuD1fVt10nFjTW5IpVu4KOjTvuo
         zD7jhi6zdzbaBp847qsxu/6fs+BeDWg6WM1a23lEsZLBnbOV3auJ+9k8vGxXhpFs1NZv
         2io97gXt2ZFBdnv5QUJfSTgScBXyoccKNlf6Xto9OxaM3CW+lNHfC/2hY01P6Tj/E9jY
         0YEQ==
X-Gm-Message-State: AOAM531QwZtKaCHJlfGXNmnRp4+irw/NZe42X5feKeefE5jj/Kiy4fYs
        44/bYCo+m+LAXyBy2woc2xU=
X-Google-Smtp-Source: ABdhPJwna+ZLplFZlfRYqNUJoffRemCmoeW6sb8yKaOsz5iQNy38QNP7G1ir+ePEw61BJavMlsJ37A==
X-Received: by 2002:a17:907:8a04:b0:6b6:1f22:a5e with SMTP id sc4-20020a1709078a0400b006b61f220a5emr23443729ejc.528.1647363297897;
        Tue, 15 Mar 2022 09:54:57 -0700 (PDT)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id l2-20020aa7cac2000000b003f9b3ac68d6sm9820877edt.15.2022.03.15.09.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 09:54:57 -0700 (PDT)
Date:   Tue, 15 Mar 2022 18:54:55 +0200
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
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH v4 net-next 03/15] net: bridge: mst: Support setting and
 reporting MST port states
Message-ID: <20220315165455.3nakoccbm7c7d2w5@skbuf>
References: <20220315002543.190587-1-tobias@waldekranz.com>
 <20220315002543.190587-4-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315002543.190587-4-tobias@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 01:25:31AM +0100, Tobias Waldekranz wrote:
> Make it possible to change the port state in a given MSTI by extending
> the bridge port netlink interface (RTM_SETLINK on PF_BRIDGE).The
> proposed iproute2 interface would be:
> 
>     bridge mst set dev <PORT> msti <MSTI> state <STATE>
> 
> Current states in all applicable MSTIs can also be dumped via a
> corresponding RTM_GETLINK. The proposed iproute interface looks like
> this:
> 
> $ bridge mst
> port              msti
> vb1               0
> 		    state forwarding
> 		  100
> 		    state disabled
> vb2               0
> 		    state forwarding
> 		  100
> 		    state forwarding
> 
> The preexisting per-VLAN states are still valid in the MST
> mode (although they are read-only), and can be queried as usual if one
> is interested in knowing a particular VLAN's state without having to
> care about the VID to MSTI mapping (in this example VLAN 20 and 30 are
> bound to MSTI 100):
> 
> $ bridge -d vlan
> port              vlan-id
> vb1               10
> 		    state forwarding mcast_router 1
> 		  20
> 		    state disabled mcast_router 1
> 		  30
> 		    state disabled mcast_router 1
> 		  40
> 		    state forwarding mcast_router 1
> vb2               10
> 		    state forwarding mcast_router 1
> 		  20
> 		    state forwarding mcast_router 1
> 		  30
> 		    state forwarding mcast_router 1
> 		  40
> 		    state forwarding mcast_router 1
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
> +static int br_mst_process_one(struct net_bridge_port *p,
> +			      const struct nlattr *attr,
> +			      struct netlink_ext_ack *extack)
> +{
> +	struct nlattr *tb[IFLA_BRIDGE_MST_ENTRY_MAX + 1];
> +	u16 msti;
> +	u8 state;
> +	int err;
> +
> +	err = nla_parse_nested(tb, IFLA_BRIDGE_MST_ENTRY_MAX, attr,
> +			       br_mst_nl_policy, extack);
> +	if (err)
> +		return err;
> +
> +	if (!tb[IFLA_BRIDGE_MST_ENTRY_MSTI]) {
> +		NL_SET_ERR_MSG_MOD(extack, "MSTI not specified");
> +		return -EINVAL;
> +	}
> +
> +	if (!tb[IFLA_BRIDGE_MST_ENTRY_STATE]) {
> +		NL_SET_ERR_MSG_MOD(extack, "State not specified");
> +		return -EINVAL;
> +	}
> +
> +	msti = nla_get_u16(tb[IFLA_BRIDGE_MST_ENTRY_MSTI]);
> +	state = nla_get_u8(tb[IFLA_BRIDGE_MST_ENTRY_STATE]);
> +
> +	br_mst_set_state(p, msti, state);

Is there any reason why this isn't propagating the error?

> +	return 0;
> +}
