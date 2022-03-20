Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A71834E1D2D
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 18:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245728AbiCTRhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 13:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245723AbiCTRhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 13:37:51 -0400
Received: from relay3.hostedemail.com (relay3.hostedemail.com [64.99.140.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E36F187B91
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 10:36:26 -0700 (PDT)
Received: from omf01.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay11.hostedemail.com (Postfix) with ESMTP id C6B39808CD;
        Sun, 20 Mar 2022 17:36:24 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf01.hostedemail.com (Postfix) with ESMTPA id 06E7A6000F;
        Sun, 20 Mar 2022 17:36:22 +0000 (UTC)
Message-ID: <7a12fd4599758b8cd5fd376db6c9a950d2ed2094.camel@perches.com>
Subject: Re: [PATCH] ath9k: initialize arrays at compile time
From:   Joe Perches <joe@perches.com>
To:     Sebastian Gottschall <s.gottschall@newmedia-net.de>,
        John Crispin <john@phrozen.org>, trix@redhat.com, toke@toke.dk,
        kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sun, 20 Mar 2022 10:36:22 -0700
In-Reply-To: <233074c3-03dc-cf8b-a597-da0fb5d98be0@newmedia-net.de>
References: <20220320152028.2263518-1-trix@redhat.com>
         <af6042d0-952f-f497-57e7-37fef45a1f76@phrozen.org>
         <233074c3-03dc-cf8b-a597-da0fb5d98be0@newmedia-net.de>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 06E7A6000F
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Stat-Signature: kyhb7gnh49rf5g8afdop8akper1tfctj
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+MWWQV3UpfM7ndNnHlITLS7MbzcF0w6oI=
X-HE-Tag: 1647797782-48345
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2022-03-20 at 18:17 +0100, Sebastian Gottschall wrote:
> Am 20.03.2022 um 17:48 schrieb John Crispin:
> > 
> > 
> > On 20.03.22 16:20, trix@redhat.com wrote:
> > > array[size] = { 0 };
> > 
> > should this not be array[size] = { }; ?!
> > 
> > If I recall correctly { 0 } will only set the first element of the 
> > struct/array to 0 and leave random data in all others elements
> > 
> >     John
> 
> You are right, john

No.  The patch is fine.

Though generally the newer code in the kernel uses

	type dec[size] = {};

to initialize stack arrays.

array stack declarations not using 0

$ git grep -P '^\t(?:\w++\s*){1,2}\[\s*\w+\s*\]\s*=\s*\{\s*\};' -- '*.c' | wc -l
213

array stack declarations using 0

$ git grep -P '^\t(?:\w++\s*){1,2}\[\s*\w+\s*\]\s*=\s*\{\s*0\s*\};' -- '*.c' | wc -l
776

Refer to the c standard section on initialization 6.7.8 subsections 19 and 21

19

The initialization shall occur in initializer list order, each initializer provided for a
particular subobject overriding any previously listed initializer for the same subobject
all subobjects that are not initialized explicitly shall be initialized implicitly the same as
objects that have static storage duration.

...

21

If there are fewer initializers in a brace-enclosed list than there are elements or members
of an aggregate, or fewer characters in a string literal used to initialize an array of known
size than there are elements in the array, the remainder of the aggregate shall be
initialized implicitly the same as objects that have static storage duration.

