Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFA31EC29D
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 21:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgFBTTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 15:19:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:34766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgFBTTu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 15:19:50 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24395206E2;
        Tue,  2 Jun 2020 19:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591125589;
        bh=bzFa4hkM8RqbHczu7os5XuvyYDQOfZ81X6m7uImTVLs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PdjJRcVLAKM+ZK6jpYtS2eaDTP6FLbh5qu9dcZ3hi+tzfsby3NcWepuM7G0rHpMmS
         5x9lno+lCpbaMgBiekvgH26goRagXOOjaNd4Pu4Kc37fAWHUr9wiqG+GRLqu4n5u3e
         sTlBdJ4BR3qyLW3x6iYfeLrvgiugcbhfBkf5qBIM=
Date:   Tue, 2 Jun 2020 12:19:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pooja Trivedi <poojatrivedi@gmail.com>
Cc:     mallesh537@gmail.com, pooja.trivedi@stackpath.com,
        josh.tway@stackpath.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        davem@davemloft.net, vakul.garg@nxp.com, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [RFC PATCH net 1/1] net/tls(TLS_SW): Add selftest for 'chunked'
 sendfile test
Message-ID: <20200602121947.40c99f51@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1591109785-14316-1-git-send-email-pooja.trivedi@stackpath.com>
References: <1591109785-14316-1-git-send-email-pooja.trivedi@stackpath.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  2 Jun 2020 14:56:25 +0000 Pooja Trivedi wrote:
> This selftest tests for cases where sendfile's 'count'
> parameter is provided with a size greater than the intended
> file size.
> 
> Motivation: When sendfile is provided with 'count' parameter
> value that is greater than the size of the file, kTLS example
> fails to send the file correctly. Last chunk of the file is
> not sent, and the data integrity is compromised.
> The reason is that the last chunk has MSG_MORE flag set
> because of which it gets added to pending records, but is
> not pushed.
> Note that if user space were to send SSL_shutdown control
> message, pending records would get flushed and the issue
> would not happen. So a shutdown control message following
> sendfile can mask the issue.
> 
> Signed-off-by: Pooja Trivedi <pooja.trivedi@stackpath.com>

Looks good, thanks. Did you submit the change to splice officially?
We'd need to get an Ack from VFS folks on it (Al Viro, probably?)
or even merge it via the vfs tree.

Minor nits below.

> diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
> index 0ea44d9..f0455e6 100644
> --- a/tools/testing/selftests/net/tls.c
> +++ b/tools/testing/selftests/net/tls.c
> @@ -198,6 +198,64 @@
>  	EXPECT_EQ(recv(self->cfd, buf, st.st_size, MSG_WAITALL), st.st_size);
>  }
>  
> +static void chunked_sendfile(struct __test_metadata *_metadata,
> +			     struct _test_data_tls *self,
> +			     uint16_t chunk_size,
> +			     uint16_t extra_payload_size)
> +{
> +	char buf[TLS_PAYLOAD_MAX_LEN];
> +	uint16_t test_payload_size;
> +	int size = 0;
> +	int ret;
> +	char tmpfile[] = ".TMP_ktls";

Could we place the file in /tmp and use mktemp()? I sometimes run the
selftests from a read-only NFS mount, and trying to create a file in
current dir breaks that.

> +	int fd = open(tmpfile, O_RDWR | O_CREAT | O_TRUNC, 0644);

We can unlink right after we open. The file won't get removed as long
as we have a reference to it, and we minimize the risk of leaving it
behind.

> +	off_t offset = 0;
> +
> +	ASSERT_GE(fd, 0);
> +	EXPECT_GE(chunk_size, 1);
> +	test_payload_size = chunk_size + extra_payload_size;
> +	ASSERT_GE(TLS_PAYLOAD_MAX_LEN, test_payload_size);
> +	memset(buf, 1, test_payload_size);
> +	size = write(fd, buf, test_payload_size);
> +	EXPECT_EQ(size, test_payload_size);
> +	fsync(fd);
> +
> +	while (size > 0) {
> +		ret = sendfile(self->fd, fd, &offset, chunk_size);
> +		EXPECT_GE(ret, 0);
> +		size -= ret;
> +	}
> +
> +	EXPECT_EQ(recv(self->cfd, buf, test_payload_size, MSG_WAITALL),
> +		  test_payload_size);
> +
> +	close(fd);
> +	unlink(tmpfile);
> +}

