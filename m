Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A03A50E6C1
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 19:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243826AbiDYRSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 13:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243841AbiDYRSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 13:18:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9320327178;
        Mon, 25 Apr 2022 10:15:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B81E61555;
        Mon, 25 Apr 2022 17:15:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F221C385A7;
        Mon, 25 Apr 2022 17:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650906900;
        bh=azwiyx9Qzz2iHjECwV38Z63IZrqsIDeUQJJ8RRIUH04=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QGwM8V39fNuvjWwbX1wgqckCCOHL+wPB9GXHM2L6qGiGea94zfToiFqejWBfIfelZ
         u11nUXYm6cKGU8vkHyJMRrW+O9aM2gqgceH2nWAzRxuLBB58XP4z5OvJkmDxn9qw2N
         k61rh2wpE/t+KIgHbBbeyhQbDBR8uoL+ybgweqCXHgjbZtQk8X4juvfwJCe9woW6e6
         xHa/TgqbKbKkggLwE6wE/gLm4QhrScCb/EyAz5Kqil29Dc8h8nd/t/62Jbh1gx9QIB
         twRNHqPh32H3/1nZs+elpZWYOy0J995A8oaQYoL/IrCMOSfuVo//U12SEB0Ip2R4Ht
         WPErAicpSEeKw==
Date:   Mon, 25 Apr 2022 10:14:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chuck Lever <chuck.lever@oracle.com>
Cc:     netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ak@tempesta-tech.com,
        borisp@nvidia.com, simo@redhat.com
Subject: Re: [PATCH RFC 4/5] net/tls: Add support for PF_TLSH (a TLS
 handshake listener)
Message-ID: <20220425101459.15484d17@kernel.org>
In-Reply-To: <165030059051.5073.16723746870370826608.stgit@oracle-102.nfsv4.dev>
References: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
        <165030059051.5073.16723746870370826608.stgit@oracle-102.nfsv4.dev>
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

On Mon, 18 Apr 2022 12:49:50 -0400 Chuck Lever wrote:
> In-kernel TLS consumers need a way to perform a TLS handshake. In
> the absence of a handshake implementation in the kernel itself, a
> mechanism to perform the handshake in user space, using an existing
> TLS handshake library, is necessary.
> 
> I've designed a way to pass a connected kernel socket endpoint to
> user space using the traditional listen/accept mechanism. accept(2)
> gives us a well-understood way to materialize a socket endpoint as a
> normal file descriptor in a specific user space process. Like any
> open socket descriptor, the accepted FD can then be passed to a
> library such as openSSL to perform a TLS handshake.
> 
> This prototype currently handles only initiating client-side TLS
> handshakes. Server-side handshakes and key renegotiation are left
> to do.
> 
> Security Considerations
> ~~~~~~~~ ~~~~~~~~~~~~~~
> 
> This prototype is net-namespace aware.
> 
> The kernel has no mechanism to attest that the listening user space
> agent is trustworthy.
> 
> Currently the prototype does not handle multiple listeners that
> overlap -- multiple listeners in the same net namespace that have
> overlapping bind addresses.

Create the socket in user space, do all the handshakes you need there
and then pass it to the kernel.  This is how NBD + TLS works.  Scales
better and requires much less kernel code.
