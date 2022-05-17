Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6295B52ADC2
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 00:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbiEQWAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 18:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiEQWAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 18:00:07 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB435133B;
        Tue, 17 May 2022 15:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ibGwroDx09LXcS70EId5UHxTm6Oqg5cS0xsZINUY8tQ=; b=X4E04QpuQIJtMamOPaVopY9r2w
        JOpVM995u3wjGau8dpV2dU9Swn7Ae0BIwm/GgQSodLAvwswzX5QT3lQt7WJk6xKY5mGpNl7fRC0GF
        D5Ly1Y5zwssdjxTyHtllO9NCGuvmfjH2pqedB2A3RXNX3BULb8n0wDUdawDlfs6K/6YKw5CS0kInQ
        Wf88wo29mqRBL1xCRIAxDCMGru1U3aEp+OK7/qgXcx+1S0ahVX9akTQdQU2O8G6kSKwfxrk35GnO9
        YOOeHtqKfmIdh5+biiP/h0Y7d0/cILsDvNyX6te9TUYUQgor+VcNZ0LwS0+7ddvFfhxZL401jjqUl
        B0tbPnFQ==;
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nr5EZ-00FqYE-7Q; Tue, 17 May 2022 22:00:03 +0000
Date:   Tue, 17 May 2022 22:00:03 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ebiggers@kernel.org, davem@davemloft.net
Subject: Re: [PATCH] vhost_net: fix double fget()
Message-ID: <YoQa4wzy9jSwDY7E@zeniv-ca.linux.org.uk>
References: <20220516084213.26854-1-jasowang@redhat.com>
 <20220516044400-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516044400-mutt-send-email-mst@kernel.org>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 16, 2022 at 04:44:19AM -0400, Michael S. Tsirkin wrote:
> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> 
> and this is stable material I guess.

It is, except that commit message ought to be cleaned up.  Something
along the lines of

----
Fix double fget() in vhost_net_set_backend()

Descriptor table is a shared resource; two fget() on the same descriptor
may return different struct file references.  get_tap_ptr_ring() is
called after we'd found (and pinned) the socket we'll be using and it
tries to find the private tun/tap data structures associated with it.
Redoing the lookup by the same file descriptor we'd used to get the
socket is racy - we need to same struct file.

Thanks to Jason for spotting a braino in the original variant of patch -
I'd missed the use of fd == -1 for disabling backend, and in that case
we can end up with sock == NULL and sock != oldsock.
----

Does the above sound sane for commit message?  And which tree would you
prefer it to go through?  I can take it in vfs.git#fixes, or you could
take it into your tree...
