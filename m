Return-Path: <netdev+bounces-2641-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DE7F702C79
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 14:16:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29C8B28128B
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 12:16:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 287A0C8D8;
	Mon, 15 May 2023 12:15:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B611C2FA
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 12:15:53 +0000 (UTC)
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B09AFE67;
	Mon, 15 May 2023 05:15:39 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
	t=1684152937; bh=B3oQ2OEcMjJUqf9Z7HsLCUErh0qFeGxtKEeg9TIzDD4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=K/3+uLu5F2UC5JKI2cxrO+8KhrjCvZCEpAW7k6sCbyzY/u7pT+LBAYbTo3fG2l1qR
	 Rq6jsTHyXSYgeUAkaiAW3nhwINWXgsMffuKht7kKMYcofcDKNY4KYw33ZbApr5CNRD
	 KK7JAzbCqnUj9BhRlJ6K5jxAhEi3j53nTV5gsxSFMTGVbC1j7QKuamEMymWd71D1Ln
	 bvGM01celoRFDnavLCJMdJnS75k+NpTXaee1YrxmUFT0BeOdizDJkuguScP44wW/49
	 IXinkuzWY9I3AKOq/xD3242GBIQXJje+rbt1vzS2OhMK70pwxO8WM3bmVSdD79vxJt
	 LZ44wVIFvN/Mg==
To: Fedor Pchelkin <pchelkin@ispras.ru>, Kalle Valo <kvalo@kernel.org>
Cc: Fedor Pchelkin <pchelkin@ispras.ru>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, Takeshi Misawa <jeliantsurux@gmail.com>,
 Alexey Khoroshilov <khoroshilov@ispras.ru>, lvc-project@linuxtesting.org,
 syzbot+b68fbebe56d8362907e8@syzkaller.appspotmail.com
Subject: Re: [PATCH] wifi: ath9k: don't allow to overwrite ENDPOINT0 attributes
In-Reply-To: <20230513214146.120963-1-pchelkin@ispras.ru>
References: <20230513214146.120963-1-pchelkin@ispras.ru>
Date: Mon, 15 May 2023 14:15:37 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87r0rhdc46.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fedor Pchelkin <pchelkin@ispras.ru> writes:

> A bad USB device is able to construct a service connection response
> message with target endpoint being ENDPOINT0 which is reserved for
> HTC_CTRL_RSVD_SVC and should not be modified to be used for any other
> services.
>
> Reject such service connection responses.
>
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
>
> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
> Reported-by: syzbot+b68fbebe56d8362907e8@syzkaller.appspotmail.com
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> ---
>  drivers/net/wireless/ath/ath9k/htc_hst.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
> index fe62ff668f75..a15d8d80df87 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_hst.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
> @@ -114,7 +114,7 @@ static void htc_process_conn_rsp(struct htc_target *target,
>  
>  	if (svc_rspmsg->status == HTC_SERVICE_SUCCESS) {
>  		epid = svc_rspmsg->endpoint_id;
> -		if (epid < 0 || epid >= ENDPOINT_MAX)
> +		if (epid <= 0 || epid >= ENDPOINT_MAX)
>  			return;

Hmm, I think we should use the ENDPOINT0 constant here, then, and maybe
add a comment above explaining that it's reserved?

-Toke

