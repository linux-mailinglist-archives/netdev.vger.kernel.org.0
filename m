Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C59F9573258
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 11:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234793AbiGMJVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 05:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbiGMJVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 05:21:02 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817D3EA173;
        Wed, 13 Jul 2022 02:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=3OMBEO5LvXeVeXcuw8XZnY/HAiyjTi9UKlfBZPl5QP8=; b=Slm1e9jU7K4DAnTnTe9ef5cc1e
        ETVKJ7ydj1dspJaa4koBUTFNxfpbCMYcoBpXeX+zf+Bkm6si98X8V/ovJ591qHYufKtQrK3eZbw6n
        49vMysZFCwC3OE76jLV/FyFhilfM4PS9Ff0JKVM1kX3QnVkmThUNp3/S78VSEKVFBBGsxF5dTa04x
        GJmidfCSY8b4yo4FNR0mK1DrN3AFA+QBQCVhY3iAltI10WymSLlspIoQXi3TjyXqCacuxjXZ4px9F
        99ySG+mN5ALZ7ey0nbGdWP2gU5hU3/wFdcDEU5HgbU/NcJqj7+9s0vYSRdTHJHCgiqqab6FRnNYr7
        Z32rXS8S0OwgViX2/TG0IdnQy+oS/fQoZPYeKhYiUBsic85M2NoSQ+cxvT/tYO83MU9z2rq1Qhzqa
        IaHJelMtOxqz/9slzOAqNlTckLef85dIsny2u5SQi5SEl53USpw4vLauOPUbpyXGBG1YYQI55WI1z
        xT28VzM1rGa0s1lADYqV/j/dcFPpkfSqiy5ufxw25DrqgXxGWWQeI7+b57BcgidztLkb9twKfAM0M
        l8PBJn07CsJR8wthQYPbevqvDf69i7NDePtO/QPsFUbneW0NQlUH6i7mEOoksmKj0mMbwh3Z0O+E/
        RaPIIbYUboDZUtOeyXabcST0VclZH6qE6xCk6/P10=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Latchesar Ionkov <lucho@ionkov.net>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        Nikolay Kichukov <nikolay@oldum.net>
Subject: Re: [V9fs-developer] [PATCH v5 11/11] net/9p: allocate appropriate reduced
 message buffers
Date:   Wed, 13 Jul 2022 11:19:48 +0200
Message-ID: <4284956.GYXQZuIPEp@silver>
In-Reply-To: <Ys3jjg52EIyITPua@codewreck.org>
References: <cover.1657636554.git.linux_oss@crudebyte.com>
 <Ys3Mj+SgWLzhQGWK@codewreck.org> <Ys3jjg52EIyITPua@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Dienstag, 12. Juli 2022 23:11:42 CEST Dominique Martinet wrote:
> Dominique Martinet wrote on Wed, Jul 13, 2022 at 04:33:35AM +0900:
> > Christian Schoenebeck wrote on Tue, Jul 12, 2022 at 04:31:36PM +0200:
> > > So far 'msize' was simply used for all 9p message types, which is far
> > > too much and slowed down performance tremendously with large values
> > > for user configurable 'msize' option.
> > > 
> > > Let's stop this waste by using the new p9_msg_buf_size() function for
> > > allocating more appropriate, smaller buffers according to what is
> > > actually sent over the wire.
> > > 
> > > Only exception: RDMA transport is currently excluded from this, as
> > > it would not cope with it. [1]
> 
> Thinking back on RDMA:
> - vs. one or two buffers as discussed in another thread, rdma will still
> require two buffers, we post the receive buffer before sending as we
> could otherwise be raced (reply from server during the time it'd take to
> recycle the send buffer)
> In practice the recv buffers should act liks a fifo and we might be able
> to post the buffer we're about to send for recv before sending it and it
> shouldn't be overwritten until it's sent, but that doesn't look quite good.
> 
> - for this particular patch, we can still allocate smaller short buffers
> for requests, so we should probably keep tsize to 0.
> rsize there really isn't much we can do without a protocol change
> though...

Good to know! I don't have any RDMA setup here to test, so I rely on what you 
say and adjust this in v6 accordingly, along with the strcmp -> flag change of 
course.

As this flag is going to be very RDMA-transport specific, I'm still scratching 
my head for a good name though.

Best regards,
Christian Schoenebeck


