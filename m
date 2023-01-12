Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB8C0666A20
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 05:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235045AbjALEU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 23:20:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235894AbjALEUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 23:20:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91CA41E3F3;
        Wed, 11 Jan 2023 20:18:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3B8F61EE6;
        Thu, 12 Jan 2023 04:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF901C433EF;
        Thu, 12 Jan 2023 04:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673497138;
        bh=V518+gFM1cwZDdgyhR7kXqz52l0CR4Q7Egq9OTV5djU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xp4/ehLMrKErnSxIpobui5bfWGR+oF8AyUlpI8aFXbl5D4xIdmTG6YnW41FoDMBk3
         sRR8zUsj+Vz4jlMlyAb97pCdzu9Ggtbyxyc07NEELQK9cUTaOyNOUlvpA/MCoaRjxy
         APpWQM0c7mHpJVpWoQSeSs+acfTdNOOKkHTdhej9iarKS9yf+frLsusuP+E1tr0Ip5
         zeMVR+9Ct84pQ2X0pUko+3LfF/r3e9Sw/OUNxnwTNwMZOUP2Qk/F0SpLw6/WLah6q5
         za5MKBWxiNl22GCLrcXMetdOjLdOK7VVitrjOBwDPX4l5AbDriLIifFB+q1Xnm/nrY
         Wz9azMFAwCHAw==
Date:   Wed, 11 Jan 2023 20:18:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH net] net: ethernet: renesas: rswitch: Fix ethernet-ports
 handling
Message-ID: <20230111201857.6610f412@kernel.org>
In-Reply-To: <20230110095559.314429-1-yoshihiro.shimoda.uh@renesas.com>
References: <20230110095559.314429-1-yoshihiro.shimoda.uh@renesas.com>
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

On Tue, 10 Jan 2023 18:55:59 +0900 Yoshihiro Shimoda wrote:
> +#define rswitch_for_each_enabled_port_reverse(priv, i)	\
> +	for (i--; i >= 0; i--)				\

nit: the typical name suffix for this sort of macro in Linux would 
be _continue_reverse - because it doesn't initialize the iterator.
It's specifically targeting error paths.

That's what list.h uses, on a quick grep I can see the same convention
is used for netdevice.h and dsa.h. Do you have counter examples?
I reckon we should throw "_continue" into the name.
