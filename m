Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16C14DB050
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 14:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355990AbiCPNFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 09:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345835AbiCPNFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 09:05:07 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B8760D1;
        Wed, 16 Mar 2022 06:03:53 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id d10so3983898eje.10;
        Wed, 16 Mar 2022 06:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=se+rvnHLTMwCDJuZUUaKeJfsDcgnDN9KN2DXN5nL3LI=;
        b=FqRhB8kJ7DAPHXMUR4z2dXdwLCMDBNZYZTQxZ8mZHljQbWDn62iBugk7EMcvIncaBu
         XkX1ohnXLsVuz41HeOEZqTzvefSfZ6GVV2ojTj8B+yE9UVomafyGCXu43qCy9UYqUZZz
         N1/1P29Zqpvkc75cVYt3YuF6wxMRhXbUEuucSLq/T5UGw3q40fX+pREKSbBezaoBeGV8
         ybfL5HMUxmYPlOCp3VHcKTZ29Krhsn4fVpaBvhm2+AFt1Z/Kx+973+5/N2BkVzFU/6nV
         rz2MtO8QBO2Szkw1W6xfAgaQek3XkEXq1Gn3QpmBBhcZzMyvoPy5WCjExWDmsDOu5rET
         IDBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=se+rvnHLTMwCDJuZUUaKeJfsDcgnDN9KN2DXN5nL3LI=;
        b=EVRBdPs22vKaEM/Vtyprm02Csedy+5pjlYX9QO57GaZ43bqP+juFtwFrS9l5CxrL7l
         BSIM46R17QAONRPdx+N1gUQyOSntdWj0acytFlBvgogqeVc+LiFbUELeiGL+0/1Bvc2Z
         erBWloJVEdp8h1Y6i0a12NDdK3E2T6dQsdTsceyBBXYzyhuU4ro78kknWpGYOoEloUuj
         +9s2opMV+dZ3gQDeSIV6cDRVvXYq4+7x/zVZPBFb0DUck3aPjsAS1WjuCd3FbnCpaCF2
         Hx7el9OGM1LHFzXLVjGxtEXFwD4zInbfsxPCfz3h7h9VvUaYsHknpTZkIi3t+AUjqxIP
         Jt2Q==
X-Gm-Message-State: AOAM531QuFijT247s3LjNIVZzGeYGVOJKH0OhicTg+RBVtouI0SXijFm
        L8BnUqjYWhYav9NPO73eL2Y=
X-Google-Smtp-Source: ABdhPJymWXJcSrB45wAn+bo52zxogrDTdURwJeZ8i8a4xfO9OafdGoinqX9reoqs6F5DLnijqYEJ3w==
X-Received: by 2002:a17:906:2991:b0:6cf:6b24:e92f with SMTP id x17-20020a170906299100b006cf6b24e92fmr26688574eje.748.1647435831497;
        Wed, 16 Mar 2022 06:03:51 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id p23-20020a170906605700b006ccebe7f75dsm875253ejj.123.2022.03.16.06.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 06:03:50 -0700 (PDT)
Date:   Wed, 16 Mar 2022 15:03:49 +0200
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
Subject: Re: [PATCH v4 net-next 10/15] net: dsa: Validate hardware support
 for MST
Message-ID: <20220316130349.kmjonrhsx7upj55h@skbuf>
References: <20220315002543.190587-1-tobias@waldekranz.com>
 <20220315002543.190587-11-tobias@waldekranz.com>
 <20220315171108.ameddbqv2sehq3pp@skbuf>
 <8735jil0m1.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8735jil0m1.fsf@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 16, 2022 at 10:15:18AM +0100, Tobias Waldekranz wrote:
> >> +int dsa_port_mst_enable(struct dsa_port *dp, bool on,
> >> +			struct netlink_ext_ack *extack)
> >> +{
> >> +	if (!on)
> >> +		return 0;
> >> +
> >> +	if (!dsa_port_supports_mst(dp)) {
> >> +		NL_SET_ERR_MSG_MOD(extack, "Hardware does not support MST");
> >> +		return -EINVAL;
> >> +	}
> >> +
> >> +	return 0;
> >> +}
> >
> > Experimenting a bit... maybe this looks tidier? We make the "if" condition
> > have the same basic structure as the previous "if (br_mst_enabled(br) &&
> > !dsa_port_supports_mst(dp))", albeit transformed using De Morgan's rules.
> >
> > {
> > 	if (!on || dsa_port_supports_mst(dp))
> > 		return 0;
> >
> > 	NL_SET_ERR_MSG_MOD(extack, "Hardware does not support MST");
> > 	return -EINVAL;
> > }
> 
> I initially had it like this. It looks tidier, yes - but to me the
> intent is less obvious when reading it. How about:
> 
> {
> 	if (on && !dsa_port_supports_mst(dp)) {
> 		NL_SET_ERR_MSG_MOD(extack, "Hardware does not support MST");
> 		return -EINVAL;
> 	}
> 
> 	return 0;
> }

Yes, let's go with this.
