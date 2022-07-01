Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72799562A2C
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 06:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233931AbiGAEFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 00:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234814AbiGAEEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 00:04:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718436B817;
        Thu, 30 Jun 2022 21:03:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E15B6621F4;
        Fri,  1 Jul 2022 04:03:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44F3C341C6;
        Fri,  1 Jul 2022 04:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656648226;
        bh=rqfYfhlzfGYglZZBCls7ltUMPPwFavhxj0MfN4ZQNIQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dKiee9SS5lH8rMRpcCH3/5+cOe7wsREfvXf/97uAbvUBZCtkSOMUWwP6jse3PTwiG
         zCQ0rB2+HNT+5OAsWEQVI+HQ+G4wtFNqTMBH4Mk30bmxBuDlQLe1EC/RWMozhqrQwT
         ZebGZTNDADRuHUEc+B6KRpw9hT5UfY5dQMEHCjLHrP/24ejy5BrEMTt+ilMJUOQhN9
         MXBiAPFCeANChePgtWJq5XO/ut7phjnVS5J+Eebt5fWnFqumT2pq8jluqb0lfvio0/
         Uc5POqkh7lY8EsyQrHxQOWQnopn6Mdx7pD6RP4tPji7SxkZWlW4tIEQzNkl1XQqLPC
         kyd0GqmVugYJg==
Date:   Thu, 30 Jun 2022 21:03:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH net V3] virtio-net: fix the race between refill work and
 close
Message-ID: <20220630210344.4ab805fe@kernel.org>
In-Reply-To: <20220701020655.86532-1-jasowang@redhat.com>
References: <20220701020655.86532-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  1 Jul 2022 10:06:55 +0800 Jason Wang wrote:
> We try using cancel_delayed_work_sync() to prevent the work from
> enabling NAPI. This is insufficient since we don't disable the source
> of the refill work scheduling. This means an NAPI poll callback after
> cancel_delayed_work_sync() can schedule the refill work then can
> re-enable the NAPI that leads to use-after-free [1].
> 
> Since the work can enable NAPI, we can't simply disable NAPI before
> calling cancel_delayed_work_sync(). So fix this by introducing a
> dedicated boolean to control whether or not the work could be
> scheduled from NAPI.

Hm, does not apply cleanly to net or Linus's tree.
