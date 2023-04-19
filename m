Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 884776E719D
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 05:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbjDSDdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 23:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjDSDdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 23:33:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E1AC40FE
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 20:33:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8316363A7F
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 03:33:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65DD7C433EF;
        Wed, 19 Apr 2023 03:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681875199;
        bh=WYqhr0gs0QI/S7bZ3TkzeQ+0TQymyEs7MY0s9TRTXns=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u30Yw7ZnMRcJXGMJTytzKW4E/t4qTzITwN0VHdGCjbiLuuMblC6DAmOmsSuRKR61G
         qeXg42PxiGpMB/W3eYhkqRIguuzzM8+I9f6ZD/hFvn4bzF/G2iq3kHOvOoGiA1ylE2
         cnwhR3B9XgayQ/PJzDvtDZO3E+zzCJlaSHvXNONDw4/UVEz1QyrwsKe6djXyvV0NN3
         XZgVVMoDA39ZVyAq8YVYJFNLfFCCBoWO6FhpbxAqbuI1BiF3FlxfvuD7F4i4FAVfoY
         90H2iymFMLPeoWNRCvQWDYNZevoagtJpl1L55GkA8GjYFjxyGODbvhI8ewsiuaccvJ
         OHBKk6OOYhkyg==
Date:   Tue, 18 Apr 2023 20:33:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Patrick McHardy <kaber@trash.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Christophe Ricard <christophe-h.ricard@st.com>,
        Johannes Berg <johannes.berg@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, Brad Spencer <bspencer@blackberry.com>
Subject: Re: [PATCH v1 net] netlink: Use copy_to_user() for optval in
 netlink_getsockopt().
Message-ID: <20230418203318.2053c4f9@kernel.org>
In-Reply-To: <20230419004246.25770-1-kuniyu@amazon.com>
References: <20230419004246.25770-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Apr 2023 17:42:46 -0700 Kuniyuki Iwashima wrote:
> Brad Spencer provided a detailed report that when calling getsockopt()
> for AF_NETLINK, some SOL_NETLINK options set only 1 byte even though such
> options require more than int as length.
> 
> The options return a flag value that fits into 1 byte, but such behaviour
> confuses users who do not strictly check the value as char.
> 
> Currently, netlink_getsockopt() uses put_user() to copy data to optlen and
> optval, but put_user() casts the data based on the pointer, char *optval.
> So, only 1 byte is set to optval.
> 
> To avoid this behaviour, we need to use copy_to_user() or cast optval for
> put_user().
> 
> Now getsockopt() accepts char as optval as the flags are only 1 byte.

I think it's worth doing, but it will change the return value on big
endian, right?
