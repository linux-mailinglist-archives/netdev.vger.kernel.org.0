Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55F2765540B
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 20:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbiLWTu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 14:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiLWTu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 14:50:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38BEE5FD3
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 11:50:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC29860AC5
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 19:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6605C433EF;
        Fri, 23 Dec 2022 19:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671825051;
        bh=ltpbZNbcDnh3N0tIPXN4VinF/MNPkZCYAUMwujEwCPg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W5BHhhIJIVKUCPnt8WCcRTMy44RJO1aofgL1vAOtIuKk7nsLABrGiCNNavie1dInt
         PqCjh/5DWp3JTeECjxllF6KeRlJ6e7kk2Yz6t6Cn0WJ//7V6ycniOVT9ihMOKtn38S
         7QjabIeHRPpmhaEQkf0as2aFzfT1ATEz2TxuxZZn9k9sYvTOgm414EQLefv5Qzm6lL
         Q2WBrFakeKr+RQxkQQjMo6vd50QT5t2t5VgRrbHaIz/fZHTqdJYLcJwjb5nE7TDU1Z
         aC1cpkgZlXHuK7VwF8NIRUWSbyYon2falxJed0ZMdFA2wgCB8xcHpSt4lDw9Z3M/SQ
         hOIYn9PL5K2oA==
Date:   Fri, 23 Dec 2022 11:50:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Francois Romieu <romieu@fr.zoreil.com>
Cc:     "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        stephen@networkplumber.org
Subject: Re: [PATCH ethtool-next v2 2/2] netlink: add netlink handler for
 get rss (-x)
Message-ID: <20221223115049.12b985b1@kernel.org>
In-Reply-To: <Y6WMIANorlX8lMfN@electric-eye.fr.zoreil.com>
References: <20221222001343.1220090-1-sudheer.mogilappagari@intel.com>
        <20221222001343.1220090-3-sudheer.mogilappagari@intel.com>
        <20221221172207.30127f4f@kernel.org>
        <IA1PR11MB6266430ED759770807768D4EE4E89@IA1PR11MB6266.namprd11.prod.outlook.com>
        <20221222180219.22b109c5@kernel.org>
        <Y6WMIANorlX8lMfN@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Dec 2022 12:08:16 +0100 Francois Romieu wrote:
> > Hex would be great, but AFAIR JSON does not support hex :(
> > Imagine dealing with this in python, or bash. Do you really
> > want the values to be strings? They will have to get converted 
> > manually to integers. So I think just making them integers is
> > best, JSON is for machines not for looking at...  
> 
> 'ip' json output does not use the suggested format.
> 
> It may be interesting to know if the experience proved it to be
> a poor choice.

Hopefully without sounding impolite let me clarify that it is precisely
*experience* using the JSON output of ip extensively in Python and Ruby
(chef) which leads me to make the suggestion.

I made the same mistake in bpftool's JSON output, formatting binary
data as hex strings so it "looks nice" :(

Unfortunately we consider JSON output to be uAPI-like so we can't
change the format now :(
