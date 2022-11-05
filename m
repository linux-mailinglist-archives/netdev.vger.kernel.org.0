Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBD261A6DE
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 03:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiKECTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 22:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiKECTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 22:19:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222457643
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 19:19:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 00772CE13C7
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 02:19:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01092C433D6;
        Sat,  5 Nov 2022 02:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667614752;
        bh=HBEBWPtlTgwka1eXOnsp0CVPd66UHkoWS1IdwzRPuPQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MWjdiWBYy90WhYHSxCanturzNaTKStqSj3dZji+RIUKJhJDtZdTUTYw1gkOG33AYn
         zXPYgNuHjJ5l7qZKQ2k7BBaoarWe+wGV8prH6taa8PkPYzeiH1mqkIU2zA91btkz89
         3KGWOy88O1H4OiqtIYuhdeRGc6rHqN4ZPK0vQ+TUFMeZ2ibDvSkd9xBm8p/mS0kczT
         mcwCd2ERWtIzwchozgpG9IBR3+nZpp+GcxUMNL+yspuHttGGlfchv/KbW8+VhHN7on
         jTtoOPpF6b1urwGfmRys7UXea0wE8xgO/Wp9oxaGW1eYzAuIstJb3YRg4BeWjw+LN0
         Pw5dbHjVD5I6Q==
Date:   Fri, 4 Nov 2022 19:19:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com
Subject: Re: [patch net-next] net: devlink: convert port_list into xarray
Message-ID: <20221104191910.1fd542e7@kernel.org>
In-Reply-To: <20221104151405.783346-1-jiri@resnulli.us>
References: <20221104151405.783346-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Nov 2022 16:14:05 +0100 Jiri Pirko wrote:
> -	list_add_tail(&devlink_port->list, &devlink->port_list);
> +	err = xa_alloc(&devlink->ports, &id, devlink_port, XA_LIMIT(id, id),
> +		       GFP_KERNEL);
> +	if (err) {
> +		mutex_destroy(&devlink_port->reporters_lock);
> +		return err;
> +	}

Odd if there isn't a cleaner API for allocating a specific ID.
Perhaps xa_insert() is what we need?
