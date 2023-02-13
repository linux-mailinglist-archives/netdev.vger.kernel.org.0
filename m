Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6FEE695370
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 22:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbjBMVzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 16:55:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbjBMVzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 16:55:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30AFF16336
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 13:55:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A459F61272
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 21:55:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFFCFC4339B;
        Mon, 13 Feb 2023 21:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676325308;
        bh=XDZ731uMktw+YCM2TKiwTkd1UhQX1UavGQ1Ak5y6L94=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FdOL9Wy8BuX1m3CLn1a8QxYbCIyK0/+G3evyIRbRguyimgbX0iqqTh8kEWu79DXpB
         YUksISOGG3UkOoupOZ+G9xd39ri9OAfsnfcKHxVQo4JVyp68jV00SpFsf/fudV/har
         QhM1CN6t3dXvDaSnBaiXs+EbUJp4Q73rS3mCnngCKO4IWLt64XvirQR+uh2Sml6L2z
         rKI7MKYGv532AZDXeyj0V7Bu2alobEmOV3LgBX1biDxqT58ZrwbfUkv88ZcOs3A70H
         87IMPCeqir+DwX9XEyjWky7YOxELI191Vy+1jkU0/7vrXYn6Os8nqt3J0YCY4rqYW8
         Zbuml2FCZ6ZrA==
Date:   Mon, 13 Feb 2023 13:55:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Chuck Lever III <chuck.lever@oracle.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "hare@suse.com" <hare@suse.com>,
        David Howells <dhowells@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        "jmeneghi@redhat.com" <jmeneghi@redhat.com>
Subject: Re: [PATCH v3 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Message-ID: <20230213135506.4e5fd36f@kernel.org>
In-Reply-To: <05d58d09-858f-5426-32e2-73f305bc98ff@suse.de>
References: <167580444939.5328.5412964147692077675.stgit@91.116.238.104.host.secureserver.net>
        <167580607317.5328.2575913180270613320.stgit@91.116.238.104.host.secureserver.net>
        <20230208220025.0c3e6591@kernel.org>
        <5D62859B-76AD-431C-AC93-C42A32EC2B69@oracle.com>
        <20230209180727.0ec328dd@kernel.org>
        <EB241BE0-8829-4719-99EC-2C3E74384FA9@oracle.com>
        <20230210100915.3fde31dd@kernel.org>
        <05d58d09-858f-5426-32e2-73f305bc98ff@suse.de>
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

On Sat, 11 Feb 2023 13:11:02 +0100 Hannes Reinecke wrote:
> > Would you be able to write the spec for it? I'm happy to help with that
> > as I mentioned. Perhaps you have the user space already hand-written
> > here but in case the mechanism/family gets reused it'd be sad if people
> > had to hand write bindings for other programming languages.  
> 
> Can you send me a pointer to the YAML specification (and parser)?
> I couldn't find anything in the linux sources; but maybe I'm looking in 
> the wrong tree or somesuch.

The ready-for-consumption specs are only in net-next, but the user
space code gen did not end up there (yet?) 

I pushed some old branch where I had started typing up user space C
code gen there:

https://github.com/kuba-moo/ynl/tree/yaml-ynl-c-wip

It's an old branch taken out of trash so there's a lot of unrelated
garbage :(  Only stuff of note would be the under tools/net/ynl/
