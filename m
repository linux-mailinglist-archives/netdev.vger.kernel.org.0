Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACDE469829A
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 18:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbjBORpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 12:45:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjBORpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 12:45:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF79E3C2B2
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 09:45:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 695BCB82324
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 17:45:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79EFC4339C;
        Wed, 15 Feb 2023 17:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676483144;
        bh=JtbHipNcNzrkn+SXL+VNcTE8CvTgKlgPAFJ9q72wdGc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f2GX6FstYYPga3ei61FHtUWRKZt+p+YkEkR91N1Polj9ltANkY+tkJn4IoHwUUuYI
         CqZ/rGxvptxnZ8TuTUQaUbX9xR1ToD/n22bR+tmM3XvTTD+xqxSUrZep3lipbyDnYs
         wxFQujka+3Hj9BEhP+kOXz1kyEERjPUtTBAnhktyYnpVnJjaFWT9hG83OHygU+xsMt
         mU1cRO6dNJy3JwRlFr6KlhyC8yZSOYF0m8D58sZGuHCvVdCVmy8LrmV6cddNVSohpR
         5YLeM5nmWP7W6m2iimglZvwtcqPwD2AiG+3Q2OSHO9C70bHnLruoMH66CXVXAiePJ4
         mnsJhBIWpr7GQ==
Date:   Wed, 15 Feb 2023 09:45:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        willemb@google.com, fw@strlen.de
Subject: Re: [PATCH net-next 2/3] net: skbuff: cache one skb_ext for use by
 GRO
Message-ID: <20230215094542.7dc0ded6@kernel.org>
In-Reply-To: <ef9ab8960763289e990b0010ee2aa761c3ee80a3.camel@redhat.com>
References: <20230215034355.481925-1-kuba@kernel.org>
        <20230215034355.481925-3-kuba@kernel.org>
        <ef9ab8960763289e990b0010ee2aa761c3ee80a3.camel@redhat.com>
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

On Wed, 15 Feb 2023 09:41:13 +0100 Paolo Abeni wrote:
> I'm wondering if napi_reuse_skb() should be touched, too? Even it's not
> directly used by the following patch...

I didn't touch it because I (sadly) don't have access to any driver
using GRO frags to test :(  But I certainly can.

What about __kfree_skb_defer() and napi_consume_skb() (basically 
the other two napi_skb_cache_put() callers) ?
