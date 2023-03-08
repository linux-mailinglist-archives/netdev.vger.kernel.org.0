Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9B586B112B
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 19:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjCHSk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 13:40:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjCHSk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 13:40:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F7FA3B5C;
        Wed,  8 Mar 2023 10:40:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0174F61913;
        Wed,  8 Mar 2023 18:40:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A4EC433D2;
        Wed,  8 Mar 2023 18:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678300855;
        bh=Yg9TytMOip7LuSWgEuWnNdqRwRNl0uOWjLSwWyVpyFY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aZzn0TktY/o9Cmny2qSEc8lS64lJRWCuBGPjeQpiw/HfoqrMzUnWypP9KxkkiRrSu
         LjmrEKP+ooTKLeEyrtlee50ww/TXXUhl+UCqWsg7z/OojYGcqYmboNye2OhXv1lXwC
         z6HRDh6nOdhJTBEwdkmbEgKyuBdAeEIz57v34Gx8=
Date:   Wed, 8 Mar 2023 10:40:54 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Soheil Hassas Yeganeh <soheil@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jens Axboe <axboe@kernel.dk>,
        Christian Brauner <brauner@kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v4 RESEND] epoll: use refcount to reduce ep_mutex
 contention
Message-Id: <20230308104054.84612fbe99e8a57ae57b5ff0@linux-foundation.org>
In-Reply-To: <f049d74b59323ed2ad16a0b52de86f157ae353ce.camel@redhat.com>
References: <e8228f0048977456466bc33b42600e929fedd319.1678213651.git.pabeni@redhat.com>
        <20230307133057.1904d8ffab2980f8e23ee3cc@linux-foundation.org>
        <f049d74b59323ed2ad16a0b52de86f157ae353ce.camel@redhat.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 08 Mar 2023 09:55:31 +0100 Paolo Abeni <pabeni@redhat.com> wrote:

> I have a process question: I understand this is queued for the mm-
> nonmm-unstable branch. Should I send a v5 with the above comments
> changes or an incremental patch or something completely different?

Either is OK.  If it's a v5 I'll usually queue a delta so people who
have a;ready reviewed can see what changed.  That delta is later
squashed and I'll use v5's changelog for the whole.

