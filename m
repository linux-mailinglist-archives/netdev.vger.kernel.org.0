Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEBC056AF5C
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 02:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236845AbiGHARk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 20:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236829AbiGHARj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 20:17:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D89A6EEA3
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 17:17:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63640B82446
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 00:17:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E4EC3411E;
        Fri,  8 Jul 2022 00:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657239456;
        bh=18EvcOfRQZ0Oq1YDmoN81IcFEOq6xziiwJ23OvvkK3k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hL39/ZGAvjhknHeVRyJv2FFHPmBsYwUMLKjzoVBQkBq0zeF64xZcQCgF3iKIfUkb7
         J5FIwveL9jQotL2xAZB84n6NP51veZ9PU+BRVj64QlIU/K7N8wgOy2V2FgjCUP9QAa
         oCFBchrnsUT9aB3pXiVf4zie3reL/XRhYV8M548YDN+Z6jy2tlHYCBEjh0dxXn1vjp
         6LAIkhDSiHVivFkOaFtFQKnkWdA19rfxcUVjo0hDTIr6YTCfNXMVBvLktG5HyqGffm
         z3+zFEzmyQ6H08fVdtLQge3eu1K5BDnB/cTrTxADmWgMXrY3zDOar6YnSdpYTfN2VE
         HUgQLdWOYsJpw==
Date:   Thu, 7 Jul 2022 17:17:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: Re: [net-next 11/15] net/tls: Multi-threaded calls to TX
 tls_dev_del
Message-ID: <20220707171726.5759eb5c@kernel.org>
In-Reply-To: <953f4a8c-1b17-cf22-9cbf-151ba4d39656@gmail.com>
References: <20220706232421.41269-1-saeed@kernel.org>
        <20220706232421.41269-12-saeed@kernel.org>
        <20220706193735.49d5f081@kernel.org>
        <953f4a8c-1b17-cf22-9cbf-151ba4d39656@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Jul 2022 01:14:32 +0300 Tariq Toukan wrote:
> > Why don't we need the flush any more? The module reference is gone as
> > soon as destructor runs (i.e. on ULP cleanup), the work can still be
> > pending, no?  
> 
> So this garbage collector work does not exist anymore. Replaced by 
> per-context works, with no accessibility to them from this function.
> It seems that we need to guarantee completion of these works. Maybe by 
> queuing them to a new dedicated queue, flushing it here.

Yup, SG.
