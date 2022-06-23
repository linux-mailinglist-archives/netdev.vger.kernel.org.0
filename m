Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC125588E6
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 21:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbiFWTb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 15:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbiFWTbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 15:31:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73BE0848A7
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 12:03:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D13B6B82338
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 19:03:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660B2C341C6;
        Thu, 23 Jun 2022 19:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656010996;
        bh=0J9qoJd4e87NhPKKWDKaOcV9w5RUwZvgBUv/+GTJTZM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JQCBDrftJQQGq+AR3SddZ0KcsscsTdulOXHqWo7sUVkFNZwWQbc7gAeFC6i3SeBGM
         QVumWjtOLZwiXc/ZsiS5yRKr9MV7PmHtyb+YEOQEU5d2Eslql9ImUThlgyXQTODbGF
         Tno7og0wWIH5vyAknKdmhnFwuRv1+8Cjg+y3+LTtMRXWWoIUd7BZoEEB1DYBwr5idf
         azGgLiCnAWB90vf687uGkEZFXs7GHclrRYEd5b83NpeE+troqNX0UeuGI+sS0Ba3I0
         i6+1/XIgNXZrsjquVnLQjb742EU/WHDdGixhgHcw6+Jk0V/BCEeMH/JqqCRIPfhSWb
         C3SzGDNptCJcg==
Date:   Thu, 23 Jun 2022 12:03:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>, Ismael Luceno <iluceno@suse.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Netlink NLM_F_DUMP_INTR flag lost
Message-ID: <20220623120307.602e1d10@kernel.org>
In-Reply-To: <da0875aa-6829-c396-0577-2e400c1041c7@gmail.com>
References: <20220615171113.7d93af3e@pirotess>
        <20220615090044.54229e73@kernel.org>
        <20220616171016.56d4ec9c@pirotess>
        <20220616171612.66638e54@kernel.org>
        <20220617150110.6366d5bf@pirotess>
        <20220622131218.1ed6f531@pirotess>
        <20220622165547.71846773@kernel.org>
        <fef8b8d5-e07d-6d8f-841a-ead4ebee8d29@gmail.com>
        <20220623090352.69bf416c@kernel.org>
        <bd76637b-0404-12e3-37b6-4bdedd625965@gmail.com>
        <20220623093609.1b104859@kernel.org>
        <da0875aa-6829-c396-0577-2e400c1041c7@gmail.com>
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

On Thu, 23 Jun 2022 11:31:34 -0600 David Ahern wrote:
> >> All of the dumps should be checking the consistency at the end of the
> >> dump - regardless of any remaining entries on a particular round (e.g.,
> >> I mentioned this what the nexthop dump does). Worst case then is DONE
> >> and INTR are set on the same message with no data, but it tells
> >> explicitly the set of data affected.  
> > 
> > Okay, perhaps we should put a WARN_ON_ONCE(seq && seq != prev_seq)
> > in rtnl_dump_all() then, to catch those who get it wrong.  
> 
> with '!(nlh->msg_flags & INTR)' to catch seq numbers not matching and
> the message was not flagged?

Yup.

Ismael, do you want to send a patch for either version of the solution
or do you expect one of us to do it?
