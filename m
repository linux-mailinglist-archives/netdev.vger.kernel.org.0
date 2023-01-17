Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5878B66D72E
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 08:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235966AbjAQHq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 02:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235920AbjAQHqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 02:46:51 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDF6244A2;
        Mon, 16 Jan 2023 23:46:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IHNi2aQpDkDbxKRjgKUG7Y3Yld9OP1h4x11WFrd3RAw=; b=k/V5SGX3Iv307bhFijCNd9+XzJ
        4OZZVg4pTrQ47wdACEoqa6fcwWyyzSJ1lhtSHglIupg7ogd211aVQJ6OI9/yW2sIpe+P6NgR5rA+D
        zNqRtkse1UOtjqHzoW29Rh63WwvJgZVhfLw5XEWctufFrI/TO1HUHHd2RPU21xWLbBKk+NZo/eIce
        IWHvU5eGdauz3vMjLWQeCKmowA6ii/hRCf0kjODMFgCNYp1z8V5c2cBjVZoKGAkmMvu4T0bJM+/Vk
        P7yrjX4O+Fv6IO2OiPYjXeV1I4PNnQIWmi55XsISaHhLJ6PXVU5fsS9KGu4JeP2alt+NdMnC0fCim
        Mp66819w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pHgfw-00DEsx-QJ; Tue, 17 Jan 2023 07:46:32 +0000
Date:   Mon, 16 Jan 2023 23:46:32 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     David Howells <dhowells@redhat.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Paolo Abeni <pabeni@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Paulo Alcantara <pc@cjr.nz>,
        linux-scsi@vger.kernel.org, Steve French <sfrench@samba.org>,
        Stefan Metzmacher <metze@samba.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Jeff Layton <jlayton@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Anna Schumaker <anna@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Tom Talpey <tom@talpey.com>, linux-rdma@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org,
        linux-nfs@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        Latchesar Ionkov <lucho@ionkov.net>,
        linux-fsdevel@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Long Li <longli@microsoft.com>, Jan Kara <jack@suse.cz>,
        linux-cachefs@redhat.com, linux-block@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Christoph Hellwig <hch@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 00/34] iov_iter: Improve page extraction (ref, pin or
 just list)
Message-ID: <Y8ZSWM2bxlRmMMTz@infradead.org>
References: <167391047703.2311931.8115712773222260073.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167391047703.2311931.8115712773222260073.stgit@warthog.procyon.org.uk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First off the liver comment:  can we cut down things for a first
round?  Maybe just convert everything using the bio based helpers
and then chunk it up?  Reviewing 34 patches across a dozen subsystems
isn't going to be easy and it will be hard to come up with a final
positive conclusion.
