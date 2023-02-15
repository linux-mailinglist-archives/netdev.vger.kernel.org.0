Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4C1697419
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 03:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbjBOCHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 21:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjBOCHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 21:07:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1DCA23852
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 18:07:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71110619C6
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 02:07:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748F4C433D2;
        Wed, 15 Feb 2023 02:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676426833;
        bh=SbxpW9B+VngoN4fP1NSdy3lq5SnfThiR3hkmZ0FjuFQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MQ5w0fA5RcGHXaWyN2h8s1zP1UsaY8vmDV6KKv7OEXLPs1xJjfJo7mdHh49TQiaD2
         zCvxVhZ80Q5PUP0gQPL1L19h2SlqBB1mTuEkYqi6meurMK0p0YwK3Lmf5ii4E3bPpE
         bmvjXhbxKaw8BSjkfFLzNp4IVkjJftNrS2cFDjNWk3eLl+DotTNP9xCpVI/fZkfhhQ
         M0Kc/l8jeiLZ8n9lk2bu0VkyriPq/PP2isY6AInfRDXL91n/I3Z+j+Ca/WKdz2F1kp
         ffTVHMDmkK714t55g7iVuUHvntN5dpapjTa05wHIT9X/PVlQgR5G40eSAGv9dgm1Xd
         Lt9zJMlTYw8Pg==
Date:   Tue, 14 Feb 2023 18:07:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <jiri@nvidia.com>, <idosch@idosch.org>
Subject: Re: [PATCH net-next 0/5][pull request] add v2 FW logging for ice
 driver
Message-ID: <20230214180712.53fc8ba2@kernel.org>
In-Reply-To: <ac41759b-29d1-acfd-7165-96bbac1840c7@intel.com>
References: <20230209190702.3638688-1-anthony.l.nguyen@intel.com>
        <20230210202358.6a2e890b@kernel.org>
        <319b4a93-bdaf-e619-b7ae-2293b2df0cca@intel.com>
        <20230213164034.406c921d@kernel.org>
        <bb0d1ef5-3045-919b-adb9-017c86c862ec@intel.com>
        <6198f4e4-51ac-a71a-ba20-b452e42a7b42@intel.com>
        <20230214151910.419d72cf@kernel.org>
        <8098982f-1488-8da2-3db1-27eecf9741ce@intel.com>
        <20230214171643.10f1590f@kernel.org>
        <ac41759b-29d1-acfd-7165-96bbac1840c7@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Feb 2023 17:33:25 -0800 Jacob Keller wrote:
> > Yes, I know, all NICs are generic IO devices now. While the only
> > example of what can go wrong we heard so far is a link flap...
> > 
> > Reimplementing a similar API in devlink with a backward compat
> > is definitely an option.
> 
> Sure. Well the interface is more of a way for firmware team to get
> debugging information out of the firmware. Its sort of like a "print"
> debugging, where information about the state of firmware during
> different activities can be recorded.
> 
> The idea is that when a problem is detected by a user, they can enable
> firmware logging to capture this data and then that can aid us in
> determining what really went wrong.
> 
> It isn't a "we detected a problem" interface. It's a "here's a bunch of
> debugging logging you asked for!" interface.

Yes, none of this sounds very usable in production. So maybe just put
the basic interface in debugfs and keep the per-module etc. whetevers
in the out of tree driver? That seems like a level of granularity
useful for development.
