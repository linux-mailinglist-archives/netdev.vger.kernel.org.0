Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E374F509EA4
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 13:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388833AbiDULjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 07:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiDULjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 07:39:17 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6311421274;
        Thu, 21 Apr 2022 04:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=FNNPCGuZp8Lz0rHUTjC37djeMue7sNKJl573jlzo1k8=; b=G8jJqvIHUlK3yjNDs1YynTCQmt
        4+s4bo8vtzhfyuszq3kDqbQLULDU4yU/BIN/2JVnhRs7mSP8aDFyJ1MvalsjyumV9k8BbqD1EHlIx
        umI00jWMJ43xZpD52hjz7bxENgf7UkeFFPTYbJyP91ObtU6gHcyCUFsmkF9ylQzeEMQf0d0PwBfF9
        pij0AFsPP0c3yGjz7gkXZYmGVt2LwcOzCTLoZ9QbNbKCMszKl+rGjZO3dejbh+LoUlecpCUNgVT1R
        YXW6S2Md6djYuweXelN8dLij3dNJjEXq8YvnAiYZyKvbhjY05+ef6Z5aOF7znKbcRpEhCbF2kZKsY
        Fk+k9PuAQFMTx700110nBmq27RR+NoS8TQ8zdUIJGjApzrKw7WsTTT14YhdNtjFhMiO2Ujx/1xqym
        arN7axRG1mYjqPtYjfHAxtwBfFghlIk3Oi67qLm7pVRlLJmSBgkXZE0vYVf2f0ksuHYdWd2RwF1Rl
        tDzIKZ8eYTKR/ql1tzejxs3XIJ+EX4tz/+G+iQeLvTYqiBxrNEaRD7u8Vm1cMeMfplzOFNva3qE7M
        QiqqRJ3QJLhSbd69jzvYb/9ECBCgmArpj/MhLOfHXM/latnvmU5eCZWoKgh//wMGAb79M/K488N0u
        axFiTxfVlQQNYmxe7Q5dLYD0oe8RKaxiFFi5ReBzg=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     asmadeus@codewreck.org, David Howells <dhowells@redhat.com>
Cc:     dhowells@redhat.com, David Kahurani <k.kahurani@gmail.com>,
        davem@davemloft.net, ericvh@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, lucho@ionkov.net,
        netdev@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        Greg Kurz <groug@kaod.org>
Subject: Re: 9p EBADF with cache enabled (Was: 9p fs-cache tests/benchmark (was: 9p
 fscache Duplicate cookie detected))
Date:   Thu, 21 Apr 2022 13:36:14 +0200
Message-ID: <1817268.LulUJvKFVv@silver>
In-Reply-To: <1050016.1650537372@warthog.procyon.org.uk>
References: <YlySEa6QGmIHlrdG@codewreck.org> <YlyFEuTY7tASl8aY@codewreck.org>
 <1050016.1650537372@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Donnerstag, 21. April 2022 12:36:12 CEST David Howells wrote:
> asmadeus@codewreck.org wrote:
> > 	int fd = open(argv[1], O_WRONLY|O_APPEND);
> > 	if (fd < 0)
> > 	
> > 		return 1;
> > 	
> > 	if (write(fd, "test\n", 5) < 0)
> 
> I think I need to implement the ability to store writes in non-uptodate
> pages without needing to read from the server as NFS does.  This may fix
> the performance drop also.
> 
> David

I hope this does not sound harsh, wouldn't it make sense to revert 
eb497943fa215897f2f60fd28aa6fe52da27ca6c for now until those issues are sorted 
out? My concern is that it might take a long time to address them, and these 
are not minor issues.

Best regards,
Christian Schoenebeck


