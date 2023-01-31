Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E430683772
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 21:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbjAaUXa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 31 Jan 2023 15:23:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbjAaUX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 15:23:29 -0500
Received: from mail.holtmann.org (coyote.holtmann.net [212.227.132.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 926719769
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 12:23:28 -0800 (PST)
Received: from smtpclient.apple (p5b3d2422.dip0.t-ipconnect.de [91.61.36.34])
        by mail.holtmann.org (Postfix) with ESMTPSA id 54BE1CED2C;
        Tue, 31 Jan 2023 21:23:27 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.2\))
Subject: Re: [PATCH v2 2/3] net/handshake: Add support for PF_HANDSHAKE
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <7CF65B71-E818-4A17-AE07-ABBEA745DBF0@oracle.com>
Date:   Tue, 31 Jan 2023 21:23:26 +0100
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        "hare@suse.com" <hare@suse.com>,
        David Howells <dhowells@redhat.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        "jmeneghi@redhat.com" <jmeneghi@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Jeff Layton <jlayton@redhat.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <865B1FD1-6419-4D81-8448-E2B291A748EE@holtmann.org>
References: <167474840929.5189.15539668431467077918.stgit@91.116.238.104.host.secureserver.net>
 <167474894272.5189.9499312703868893688.stgit@91.116.238.104.host.secureserver.net>
 <20230128003212.7f37b45c@kernel.org>
 <860B3B8A-1322-478E-8BF9-C5A3444227F7@oracle.com>
 <20230130203526.52738cba@kernel.org>
 <9B7B66AA-E885-4317-8FE7-C9ABC94E027C@oracle.com>
 <20230131113029.7647e475@kernel.org>
 <7CF65B71-E818-4A17-AE07-ABBEA745DBF0@oracle.com>
To:     Chuck Lever III <chuck.lever@oracle.com>
X-Mailer: Apple Mail (2.3696.120.41.1.2)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chuck,

>>> And, do you have a preferred mechanism or code sample for
>>> installing a socket descriptor? 
>> 
>> I must admit - I don't.
> 
> As part of responding to the handshake daemon's netlink call,
> I'm thinking of doing something like:
> 
> get_unused_fd_flags(), then sock_alloc_file(), and then fd_install() 

can we be really careful here. fd passing over Unix sockets is already
complicated to get right on the receiver side. We had this with D-Bus
and man, can you screw up things here. The problem is really that your
fd is part of the receiving process as soon as you receive that message
and you are _required_ to take care of it. Simple things like not
setting CLOEXC is already a path to disaster. And Unix sockets have
SCM_RIGHTS and other fun stuff. I don’t remember having that for
Netlink. And don’t forget the SELinux etc. folks that might want to
have some control here.

Regards

Marcel

