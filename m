Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D83E5198A3
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 09:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345706AbiEDHvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 03:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345505AbiEDHvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 03:51:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74D013F03;
        Wed,  4 May 2022 00:48:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53726B821D8;
        Wed,  4 May 2022 07:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15143C385A5;
        Wed,  4 May 2022 07:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651650492;
        bh=m64RQCqyjvzWxiO7fknKK0SA5V08XscCrerNlOARsp8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=QJlVydFQ9EKJEIznsNdV8CBg4DU9tA4As27tQIGFCjanNC2wgU3vtgxXZKEePDbmr
         ChPd9gy5ScO9j41YNrdidOUGpLoeOe5pSpARmg/IPtcaPkzf2ytMqawGVrqK21ovW2
         fbj3q2xVaW8k03juchaWUT3v/SPVf9uPo8Hz+Eb/EF7Q6FFCdNucVNCFGSR65R4KpO
         puq0ERGTRPtJoQD8pIoaMn4MDzl02AkC/QKQv5hvxSQPgh3OkBLBxEzSE2PU1WcQDq
         9aieKNA66bMP4v0sa+kDzUl2LE1wvK97Z9kHqzuyOhIVh13OzWiB6bcV+pgxHIMJuw
         2JuRoJ75jYbBw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Robert Marko <robimarko@gmail.com>
Cc:     Thibaut <hacks@slashdirt.org>,
        Christian Lamparter <chunkeey@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ath10k: support bus and device specific API 1 BDF selection
References: <20211009221711.2315352-1-robimarko@gmail.com>
        <163890036783.24891.8718291787865192280.kvalo@kernel.org>
        <CAOX2RU5mqUfPRDsQNSpVPdiz6sE_68KN5Ae+2bC_t1cQzdzgTA@mail.gmail.com>
        <09a27912-9ea4-fe75-df72-41ba0fa5fd4e@gmail.com>
        <CAOX2RU6qaZ7NkeRe1bukgH6OxXOPvJS=z9PRp=UYAxMfzwD2oQ@mail.gmail.com>
        <EC2778B3-B957-4F3F-B299-CC18805F8381@slashdirt.org>
        <CAOX2RU7FOdSuo2Jgo0i=8e-4bJwq7ahvQxLzQv_zNCz2HCTBwA@mail.gmail.com>
        <CAOX2RU7d9amMseczgp-PRzdOvrgBO4ZFM_+hTRSevCU85qT=kA@mail.gmail.com>
        <70a8dd7a-851d-686b-3134-50f21af0450c@gmail.com>
        <7DCB1B9A-D08E-4837-B2FE-6DA476B54B0D@slashdirt.org>
        <CAOX2RU7kF8Da8p_tHwuE-8YMXr5ZtWU2iL6ZY+UR+1OvGcyn+w@mail.gmail.com>
Date:   Wed, 04 May 2022 10:48:04 +0300
In-Reply-To: <CAOX2RU7kF8Da8p_tHwuE-8YMXr5ZtWU2iL6ZY+UR+1OvGcyn+w@mail.gmail.com>
        (Robert Marko's message of "Tue, 3 May 2022 17:58:03 +0200")
Message-ID: <87sfppagcr.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Robert Marko <robimarko@gmail.com> writes:

> On Wed, 16 Feb 2022 at 22:55, Thibaut <hacks@slashdirt.org> wrote:
>>
>> Hi,
>>
>> > Le 16 f=C3=A9vr. 2022 =C3=A0 22:19, Christian Lamparter <chunkeey@gmai=
l.com> a =C3=A9crit :
>> >
>> > Hi,
>> >
>> > On 16/02/2022 14:38, Robert Marko wrote:
>> >> Silent ping,
>> >> Does anybody have an opinion on this?
>> >
>> > As a fallback, I've cobbled together from the old scripts that
>> > "concat board.bin into a board-2.bin. Do this on the device
>> > in userspace on the fly" idea. This was successfully tested
>> > on one of the affected devices (MikroTik SXTsq 5 ac (RBSXTsqG-5acD))
>> > and should work for all MikroTik.
>> >
>> > "ipq40xx: dynamically build board-2.bin for Mikrotik"
>> > <https://git.openwrt.org/?p=3Dopenwrt/staging/chunkeey.git;a=3Dcommit;=
h=3D52f3407d94da62b99ba6c09f3663464cccd29b4f>
>> > (though I don't think this link will stay active for
>> > too long.)
>>
>> IMHO Robert=E2=80=99s patch addresses an actual bug in ath10k whereby the
>> driver sends the same devpath for two different devices when
>> requesting board-1 BDF, which doesn=E2=80=99t seem right.
>>
>> Your proposal is less straightforward than using unmodified board-1
>> data (as could be done if the above bug did not occur) and negates
>> the previous efforts not to store this data on flash (using instead
>> the kernel=E2=80=99s documented firmware sysfs loading facility - again
>> possible without the above issue).
>
> Kalle, any chance of reviewing this? It just brings the board data in
> line with caldata as far as naming goes.

Sorry for the delay in review. So the original idea was that board.bin
would be only used by developers for testing purposes only and normal
users will use the board file automatically from board-2.bin. It's a
shame if Mikrotik broke this, it's not ideal if there are so many
different ways to use board files. I need to think a bit about this.

The patch is now in pending branch for build testing:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=3Dp=
ending&id=3Deda838c3941863a486f7fced4b739de6fc80e857

I also fixed two checkpatch warnings:

drivers/net/wireless/ath/ath10k/core.c:1252: line length of 93 exceeds 90 c=
olumns
drivers/net/wireless/ath/ath10k/core.c:1253: line length of 96 exceeds 90 c=
olumns

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
