Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F39335917C3
	for <lists+netdev@lfdr.de>; Sat, 13 Aug 2022 02:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbiHMANY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 20:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiHMANW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 20:13:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31D68FD56
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 17:13:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AF66618C4
        for <netdev@vger.kernel.org>; Sat, 13 Aug 2022 00:13:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E543C433D6;
        Sat, 13 Aug 2022 00:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660349600;
        bh=0eZDSAkMX5BjvUFFPp1/nITX/fIEFpOwCALWaMOB4z4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fsPuxNg1c57thLkorZ+A8T9C7Jv2ihGv1NPGk3ThUpYhBpUJctZtF5+zwc5HoVeJz
         D6hLq0cQjNSywDzReX+jM9GmRJsWZneajviKm0gyJSeLza/VJcr5JRr35Yn107emFw
         bMi1Uv7+9YBzycnru+mCMcRR+N8KZgfLuoaqghXEgqhXtFPvo7Z5kLknasATity82t
         DfsYhNf6YfRhpt8nXuhBTChSMj6dh3ZwjdXK8bAyeRojikxe+7Ip2iiDZvyPQH490U
         Z7tAiC4fc0eQHBwigW8IsapQ7MBaGYNzUVRv8+b0jCwwAGkHA4fNuqRX08w8HSOXMo
         sG0l0YligXo8g==
Date:   Fri, 12 Aug 2022 17:13:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        Michal Jaron <michalx.jaron@intel.com>, netdev@vger.kernel.org,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: Re: [PATCH net 2/2] ice: Fix call trace with null VSI during VF
 reset
Message-ID: <20220812171319.495e33f5@kernel.org>
In-Reply-To: <20220811161714.305094-3-anthony.l.nguyen@intel.com>
References: <20220811161714.305094-1-anthony.l.nguyen@intel.com>
        <20220811161714.305094-3-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Aug 2022 09:17:14 -0700 Tony Nguyen wrote:
> This WARN_ON() is unnecessary and causes call trace, despite that
> call trace, driver still works. There is no need for this warn
> because this piece of code is responsible for disabling VF's Tx/Rx
> queues when VF is disabled, but when VF is already removed there
> is no need to do reset or disable queues.

Can't you flush the service work when disabling VFs instead?
Seems better to try to keep the system in a consistent state
than add "if NULL return;" in random places :S
