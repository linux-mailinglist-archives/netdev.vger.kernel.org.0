Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDC106975B4
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 06:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbjBOFJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 00:09:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231966AbjBOFJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 00:09:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741A01D905;
        Tue, 14 Feb 2023 21:09:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CB68B82004;
        Wed, 15 Feb 2023 05:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61EE6C433D2;
        Wed, 15 Feb 2023 05:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676437766;
        bh=rB/tKPdz+iS6ujMDXMm5h1XtxIQSab85DCZqrH4RD6A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LbB6y0TH2vz/WMkL+/xq/8+ceESr2pOlSH647PcLACtbilyeFiznil+WXdimYsh0+
         VybwDS1MGN0sFTHa/D19ShVQJa/ISv9Nn4yphqXHhbbsUdBthxs/L+CIxgy1HHHHXr
         29D2CCc9iBczbP6ykVt8q1CYPhlrT0hbSC3+sT/Oa+Gu/qwK2e9IrXD9kAY2IAww/9
         CwrdVcAh9xH6rJf0Bb8M6e2IPM5KCxcEmKRdOSZd/ksP4Qp+SsAR2PEtoNLBewLTaO
         ONYC2OH7UWv0kvd+ZiN427c1+qCTY4dOVULG4zU7XpBaA3SekRyEtaYpBJI8cH95h8
         pqVlwlU5P2UkA==
Date:   Tue, 14 Feb 2023 21:09:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org, Vadim Fedorenko <vfedorenko@novek.ru>,
        Frantisek Krenzelok <fkrenzel@redhat.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Apoorv Kothari <apoorvko@amazon.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Gal Pressman <gal@nvidia.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH net-next v2 2/5] tls: block decryption when a rekey is
 pending
Message-ID: <20230214210925.23c005b1@kernel.org>
In-Reply-To: <4a9a82a0eaa47319e0e7a7fe525bd37f25b61cb5.1676052788.git.sd@queasysnail.net>
References: <cover.1676052788.git.sd@queasysnail.net>
        <4a9a82a0eaa47319e0e7a7fe525bd37f25b61cb5.1676052788.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Feb 2023 12:17:39 +0100 Sabrina Dubroca wrote:
> @@ -2141,6 +2178,12 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
>  	if (err < 0)
>  		return err;
>  
> +	/* a rekey is pending, let userspace deal with it */
> +	if (unlikely(ctx->key_update_pending)) {
> +		err = -EKEYEXPIRED;
> +		goto splice_read_end;
> +	}

This will prevent splicing peek()'ed data.
Just put the check in tls_rx_rec_wait().
