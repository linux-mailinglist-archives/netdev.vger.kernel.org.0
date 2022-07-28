Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD5A58366A
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 03:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234932AbiG1Bg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 21:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiG1Bgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 21:36:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664194D81C;
        Wed, 27 Jul 2022 18:36:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06813B8224E;
        Thu, 28 Jul 2022 01:36:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD37C433C1;
        Thu, 28 Jul 2022 01:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658972208;
        bh=DnonMiuWXIiuzZDXL8pNnHlEBP04K89tqhUudaTWyW4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dNCsZuXFlDoDjpOHeM3xi6E8xS9DNsogbnl15CBPmj7ogMT7BmE0UR54KlN6yJ6EX
         GhEB/jVRpViOcoVlRVjkNgyK03DeMJ87yZxrLPbCcIpPkKnBqN2D/wreTzQVd8e0MO
         cmV7Q3EzBCLPzZT6zI/3ghxQkEsH4xwRuk8+40sRDs3n5Aux2FkoNH/4nPvQyqDyRP
         1Mi8kCO7CinKNrt6zeRYs0zluWjr1q5YUwG0/SeuY6O8W6duObF5l67FhXLKlURpPJ
         myGZC29GJ+ZTLhUJJeIBj0U6hCE8OPwEAYSxUEsl3V9miv2dGnNUktfMJIqP8ibyM+
         JdeacHjPn9qtQ==
Date:   Wed, 27 Jul 2022 18:36:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-hams@vger.kernel.org, ralf@linux-mips.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] netrom: fix sleep in atomic context bugs in
 timer handlers
Message-ID: <20220727183647.23ae46f8@kernel.org>
In-Reply-To: <20220726032420.5516-1-duoming@zju.edu.cn>
References: <20220726032420.5516-1-duoming@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Jul 2022 11:24:20 +0800 Duoming Zhou wrote:
> nr_heartbeat_expiry
>   nr_write_internal
>     nr_transmit_buffer

void nr_transmit_buffer(struct sock *sk, struct sk_buff *skb)
{
[...]
	if (!nr_route_frame(skb, NULL)) {

>       nr_route_frame

int nr_route_frame(struct sk_buff *skb, ax25_cb *ax25)
{
[...]
	if (ax25 != NULL) {
		ret = nr_add_node(nr_src, "", &ax25->dest_addr, ax25->digipeat,

ax25 must be NULL on this path AFAICT.

>         nr_add_node
>           kmemdup(..,GFP_KERNEL) //may sleep
