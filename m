Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26B41695577
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 01:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjBNAkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 19:40:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjBNAkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 19:40:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636177682
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 16:40:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11B9CB81A31
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 00:40:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB18C433D2;
        Tue, 14 Feb 2023 00:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676335235;
        bh=X0mKUkKWuRrhRr22wymlUpqScHbSdwSbZqbJIA+AESc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QHp1shwnMhJHYMMPrDaW60QpUbEzFznfqAH+1D37uBeKkuDlLMmWZB+n5ljB5fWgA
         7hsIVW5HwZX+iwjVEe7XQZUMMLJ/Vt/QnKfusbX135QEUg/HAzqLKGbEeyvNUvZ38u
         Dgczy20smXDtEoxyaAsC5Qe/hW3FEBjAzr+nQ7gydh+lW+M9J42WZsX3k4eWEsYoSo
         vP4YBXDTymuf6i34p/oMmNuFtklkpaYjk5iDK6BZcIkD75kLmgUpQUs57xgNm5qB/8
         rKmGHr95HaiyGz25LBFuLXq5itDvgU9WdzMl9K542QiR6lDiLYbsZgaTAtNA9v6L5g
         JIHmCjrK5mY9g==
Date:   Mon, 13 Feb 2023 16:40:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <jacob.e.keller@intel.com>,
        <jiri@nvidia.com>, <idosch@idosch.org>
Subject: Re: [PATCH net-next 0/5][pull request] add v2 FW logging for ice
 driver
Message-ID: <20230213164034.406c921d@kernel.org>
In-Reply-To: <319b4a93-bdaf-e619-b7ae-2293b2df0cca@intel.com>
References: <20230209190702.3638688-1-anthony.l.nguyen@intel.com>
        <20230210202358.6a2e890b@kernel.org>
        <319b4a93-bdaf-e619-b7ae-2293b2df0cca@intel.com>
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

On Mon, 13 Feb 2023 15:46:53 -0800 Paul M Stillwell Jr wrote:
> On 2/10/2023 8:23 PM, Jakub Kicinski wrote:
> > Can you describe how this is used a little bit?
> > The FW log is captured at some level always (e.g. warns)
> > or unless user enables _nothing_ will come out?
> 
> My understanding is that the FW is constantly logging data into internal 
> buffers. When the user indicates what data they want and what level they 
> want then the data is filtered and output via either the UART or the 
> Admin queues. These patches retrieve the FW logs via the admin queue 
> commands.

What's the trigger to perform the collection?

If it's some error condition / assert in FW then maybe it's worth
wrapping it up (or at least some portion of the functionality) into
devlink health?

AFAIU the purpose of devlink health is exactly to bubble up to the host
asserts / errors / crashes in the FW, with associated "dump".

> The output from the FW is a binary blob that a user would send back to 
> Intel to be decoded. This is only used for troubleshooting issues where 
> a user is working with someone from Intel on a specific problem.

I believe that's in line with devlink health. The devlink health log 
is "formatted" but I really doubt that any user can get far in debugging
without vendor support.

> > On Thu,  9 Feb 2023 11:06:57 -0800 Tony Nguyen wrote:  
> >> devlink dev param set <pci dev> name fwlog_enabled value <true/false> cmode runtime
> >> devlink dev param set <pci dev> name fwlog_level value <0-4> cmode runtime
> >> devlink dev param set <pci dev> name fwlog_resolution value <1-128> cmode runtime  
> > 
> > If you're using debugfs as a pipe you should put these enable knobs
> > in there as well.  
> 
> My understanding is that debugfs use as a write mechanism is frowned on. 
> If that's not true and if we were to submit patches that used debugfs 
> instead of devlink and they would be accepted then I'll happily do that. :)

Frowned upon, but any vendor specific write API is frowned up, I don't
think the API is the matter of devlink vs debugfs. To put it differently -
a lot of people try to use devlink params or debugfs without stopping
to think about how the interface can be used and shared across vendors.
Or even more sadly - how the end user will integrate them into their
operations / fleet management.

> Or add a proper devlink command to carry all this
> > information via structured netlink (fw log + level + enable are hardly
> > Intel specific).  
> 
> I don't know how other companies FW interface works so wouldn't assume 
> that I could come up with an interface that would work across all devices.

Let's think about devlink health first.
