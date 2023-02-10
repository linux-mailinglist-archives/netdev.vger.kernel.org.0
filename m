Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDBF691680
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 03:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjBJCHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 21:07:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbjBJCHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 21:07:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB58A6E9B6
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 18:07:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49CA961C40
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 02:07:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7C9C433EF;
        Fri, 10 Feb 2023 02:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675994848;
        bh=iTAiIu9VZVPDjmtkBulg8TPg6luFoVV0P6Rk1L/n04I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OODleNT9PuPDXFLMRc2GmksCH1Bqhl/AdP8EuIQzT6GmMTmuBeX5CnxYQr2cbTvrD
         GTohaBvBeAsjCS5PUVe/DewaHQ3hqkW4uVOY4ihhIKLUkO0W64+iVAIkpN3Y2V2UhN
         C6u0Pyump9ZKBlfCD6CKMbkwBjfX9oRo96ZtolRMlBdDMiC/T0TQ3p2Ex4yNVqLqa9
         5R4bRfMeDYchp5EdoFwV2ez1vVv/G1ohorDcuugHzPatjXTMZYYhXRetBFqFIzPMLg
         Xh9N6cF8KNTviZP/t/EKXQwWG1iDa8YdC38dOHT//x4fdibQqtb299E22irGf8Viss
         4QA9KlZ47J8bA==
Date:   Thu, 9 Feb 2023 18:07:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "hare@suse.com" <hare@suse.com>,
        David Howells <dhowells@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        "jmeneghi@redhat.com" <jmeneghi@redhat.com>
Subject: Re: [PATCH v3 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Message-ID: <20230209180727.0ec328dd@kernel.org>
In-Reply-To: <5D62859B-76AD-431C-AC93-C42A32EC2B69@oracle.com>
References: <167580444939.5328.5412964147692077675.stgit@91.116.238.104.host.secureserver.net>
        <167580607317.5328.2575913180270613320.stgit@91.116.238.104.host.secureserver.net>
        <20230208220025.0c3e6591@kernel.org>
        <5D62859B-76AD-431C-AC93-C42A32EC2B69@oracle.com>
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

On Thu, 9 Feb 2023 15:43:06 +0000 Chuck Lever III wrote:
> >> @@ -29,6 +29,7 @@
> >> #define NETLINK_RDMA		20
> >> #define NETLINK_CRYPTO		21	/* Crypto layer */
> >> #define NETLINK_SMC		22	/* SMC monitoring */
> >> +#define NETLINK_HANDSHAKE	23	/* transport layer sec handshake requests */  
> > 
> > The extra indirection of genetlink introduces some complications?  
> 
> I don't think it does, necessarily. But neither does it seem
> to add any value (for this use case). <shrug>

Our default is to go for generic netlink, it's where we invest most time
in terms of infrastructure. It can take care of attribute parsing, and
allows user space to dump information about the family (eg. the parsing
policy). Most recently we added support for writing the policies in
(simple) YAML:

https://docs.kernel.org/next/userspace-api/netlink/intro-specs.html

It takes care of a lot of the netlink tedium. If you're willing to make
use of it I'm happy to help converting etc. We merged this stuff last
month, so there are likely sharp edges.
