Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0564C6EDB59
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 07:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbjDYFuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 01:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbjDYFuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 01:50:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107077AA8;
        Mon, 24 Apr 2023 22:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87CA4627EB;
        Tue, 25 Apr 2023 05:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C301FC433D2;
        Tue, 25 Apr 2023 05:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682401813;
        bh=i1KJx66tie8E/QmmcYEegruNbhZnQ6ejhZnZzsHL7UA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=TgbqspZwjxalduzfuBR8kd0JK0l1gycFe69A/YzTLna7sDqyZ3+Z8N3XADPpyiPXb
         3sVKC98nsmt6lQTxohvDEPttqQM2WVSfxiZtTIWeypVFRApCW0QD/PZlqa/P0X690x
         qQF9wSNfSdequUg6734WLa/nnWrwzKbyUIlXSher+xmrPzjkuppDLmaUX99R9SKksy
         pF71T0dMW9NLNsE8KoO7FXywphtpE63UZc02p/8X0GqcXcYvEaOigBeppNKUNsPQMO
         qX3CrkEvbSj8d7az3WA2pWwPPp847NcYQysrtD3kFv9u+YyXqydoP31eiFaIN90FgQ
         R7+7l6SGiKbug==
From:   Kalle Valo <kvalo@kernel.org>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     Simon Horman <simon.horman@corigine.com>,
        Peter Seiderer <ps.report@gmx.net>,
        linux-wireless@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gregg Wonderly <greggwonderly@seqtechllc.com>
Subject: Re: [PATCH v1] wifi: ath9k: fix AR9003 mac hardware hang check register offset calculation
References: <20230420204316.30475-1-ps.report@gmx.net>
        <ZEOf7LXAkdLR0yFI@corigine.com> <87bkjgmd9g.fsf@toke.dk>
Date:   Tue, 25 Apr 2023 08:50:08 +0300
In-Reply-To: <87bkjgmd9g.fsf@toke.dk> ("Toke \=\?utf-8\?Q\?H\=C3\=B8iland-J\?\=
 \=\?utf-8\?Q\?\=C3\=B8rgensen\=22's\?\= message of
        "Sat, 22 Apr 2023 12:18:03 +0200")
Message-ID: <87a5ywqzn3.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:

> Simon Horman <simon.horman@corigine.com> writes:
>
>>> -	for (i =3D 0; i < NUM_STATUS_READS; i++) {
>>> -		if (queue < 6)
>>> -			dma_dbg_chain =3D REG_READ(ah, AR_DMADBG_4);
>>> -		else
>>> -			dma_dbg_chain =3D REG_READ(ah, AR_DMADBG_5);
>>> +	if (queue < 6) {
>>> +		dbg_reg =3D AR_DMADBG_4;
>>> +		reg_offset =3D i * 5;
>>
>> Hi Peter,
>>
>> unless my eyes are deceiving me, i is not initialised here.
>
> Nice catch! Hmm, I wonder why my test compile didn't complain about
> that? Or maybe it did and I overlooked it? Anyway, Kalle, I already
> delegated this patch to you in patchwork, so please drop it=20

Ok, will drop.

> and I'll try to do better on reviewing the next one :)

No worries, reviewing is hard and things always slip past. But great
that we now have more people reviewing, thanks Simon for catching this.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
