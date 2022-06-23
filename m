Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D37EA558B3F
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 00:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiFWWd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 18:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiFWWd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 18:33:26 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F22A849930;
        Thu, 23 Jun 2022 15:33:23 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 476F85ECC7F;
        Fri, 24 Jun 2022 08:33:22 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o4VO4-00AGXa-Gs; Fri, 24 Jun 2022 08:33:20 +1000
Date:   Fri, 24 Jun 2022 08:33:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, "tgraf@suug.ch" <tgraf@suug.ch>,
        Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH RFC 29/30] NFSD: Convert the filecache to use rhashtable
Message-ID: <20220623223320.GG1098723@dread.disaster.area>
References: <165590626293.75778.9843437418112335153.stgit@manet.1015granger.net>
 <165590735674.75778.2489188434203366753.stgit@manet.1015granger.net>
 <20220623003822.GF1098723@dread.disaster.area>
 <1BB6647C-799E-463F-BF63-55B48450FF29@oracle.com>
 <2F100B0A-04F2-496D-B59F-A90493D20439@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2F100B0A-04F2-496D-B59F-A90493D20439@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62b4ea33
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=IkcTkHD0fZMA:10 a=JPEYwPQDsx4A:10 a=07d9gI8wAAAA:8 a=7-415B0cAAAA:8
        a=oSJpYEgRxW49ZuJqY5AA:9 a=QEXdDO2ut3YA:10 a=e2CUPOnPG4QKp8I52DXD:22
        a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 23, 2022 at 05:27:20PM +0000, Chuck Lever III wrote:
> Also I just found Neil's nice rhashtable explainer:
> 
>    https://lwn.net/Articles/751374/
> 
> Where he writes that:
> 
> > Sometimes you might want a hash table to potentially contain
> > multiple objects for any given key. In that case you can use
> > "rhltables" — rhashtables with lists of objects.
> 
> I believe that is the case for the filecache. The hash value is
> computed based on the inode pointer, and therefore there can be more
> than one nfsd_file object for a particular inode (depending on who
> is opening and for what access). So I think filecache needs to use
> rhltable, not rhashtable. Any thoughts from rhashtable experts?

Huh, I assumed the file cache was just hashing the whole key so that
every object in the rht has it's own unique key and hash and there's
no need to handle multiple objects per key...

What are you trying to optimise by hashing only the inode *pointer*
in the nfsd_file object keyspace?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
