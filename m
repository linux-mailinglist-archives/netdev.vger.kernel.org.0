Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0459510116
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 16:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351791AbiDZO6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 10:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351798AbiDZO6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 10:58:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2275D55B1;
        Tue, 26 Apr 2022 07:55:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1026614ED;
        Tue, 26 Apr 2022 14:55:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6ECC385AA;
        Tue, 26 Apr 2022 14:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650984906;
        bh=mBBJfMdQEAD7EAvlp5VzkWfv+DhsEhFD059k90qHrY8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jJbrM3gMgGDpbLfXpV1GxS5xAGIKT9oFkVUo8elExDVKlC36ei9tGM8VO/S08FI/g
         IutRjZMnUIJUjhkd1Cq++lQIeb1o36Wh09gi8lzx3cjviH9bS1WLEwJ1lmX4wDNZB8
         lgZ/joo0wBg05ickLxda9QVf8w7EHAmpz1BeAYaFD38OThOjsiooYP1stXAAZ7g5/A
         r0j5TMS+StWVFVN7thO6oj2fJHT2639aJHJ0Xlu39lzsAWLZ3MQZD3F0pgxfyHB602
         MGogFrAx2zyevx4MzX79IVhGcoVX8OK0E/B6Kq5fbC1eFsxD7WiJJ98F4kQOAtNTVV
         PT6Gg37A6BYUQ==
Date:   Tue, 26 Apr 2022 07:55:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "ak@tempesta-tech.com" <ak@tempesta-tech.com>,
        "borisp@nvidia.com" <borisp@nvidia.com>,
        "simo@redhat.com" <simo@redhat.com>
Subject: Re: [PATCH RFC 4/5] net/tls: Add support for PF_TLSH (a TLS
 handshake listener)
Message-ID: <20220426075504.18be4ee2@kernel.org>
In-Reply-To: <E8809EC2-D49A-4171-8C88-D5E24FFA4079@oracle.com>
References: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
        <165030059051.5073.16723746870370826608.stgit@oracle-102.nfsv4.dev>
        <20220425101459.15484d17@kernel.org>
        <E8809EC2-D49A-4171-8C88-D5E24FFA4079@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Apr 2022 13:48:20 +0000 Chuck Lever III wrote:
> > Create the socket in user space, do all the handshakes you need there
> > and then pass it to the kernel.  This is how NBD + TLS works.  Scales
> > better and requires much less kernel code.  
> 
> The RPC-with-TLS standard allows unencrypted RPC traffic on the connection
> before sending ClientHello. I think we'd like to stick with creating the
> socket in the kernel, for this reason and for the reasons Hannes mentions
> in his reply.

Umpf, I presume that's reviewed by security people in IETF so I guess
it's done right this time (tm).

Your wording seems careful not to imply that you actually need that,
tho. Am I over-interpreting?
