Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0056141FD
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 00:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiJaXxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 19:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiJaXw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 19:52:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717866359;
        Mon, 31 Oct 2022 16:52:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1036B614F7;
        Mon, 31 Oct 2022 23:52:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB7AAC433D7;
        Mon, 31 Oct 2022 23:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667260377;
        bh=reJhJKIjrJBaa5YSlpQcaHFpVfQUyXnc4HNWstqjvoo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hWC3cO6ZXynA9AerNMicDQUXhVl9/0dcQWqvkzRXB9TdgGuBxLSBBkzbsvpctAlJI
         6Dt5ojpPd8/faGjBQlYfxX+Rn9so1SvZNUYlnAegWNlVIxlfdGXVMJKqb55M93LYaE
         i2gYJgLppclUgacahd/uqeruUKvZazonABhgIgn7MuvexMvqq4D5TMtQMhQtUSLzxw
         QwMNjSgkfXL1T9ZUC3jU6eCKC03/CN2XW+eMnhR84JzjHQepAKiLGqHoEJgG4kfhuR
         TG2c8QOxbI4RuZyH1r2GuBXsWJlZ0OKKR6jHpRjhO+n+FTnRfuJ+7JJrjutKhpQAlq
         XLvWb2+qmxjYA==
Date:   Mon, 31 Oct 2022 16:52:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cai Huoqing <cai.huoqing@linux.dev>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        Bin Chen <bin.chen@corigine.com>,
        Krzysztof =?UTF-8?B?V2lsY3p5xYRza2k=?= <kw@linux.com>,
        Peter Chen <peter.chen@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: hinic: Add control command support for VF PMD
 driver in DPDK
Message-ID: <20221031165255.6a754aad@kernel.org>
In-Reply-To: <20221029075335.GA9148@chq-T47>
References: <20221026125922.34080-1-cai.huoqing@linux.dev>
        <20221026125922.34080-2-cai.huoqing@linux.dev>
        <20221027110312.7391f69f@kernel.org>
        <20221028045655.GB3164@chq-T47>
        <20221028085651.78408e2c@kernel.org>
        <20221029075335.GA9148@chq-T47>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 29 Oct 2022 15:53:35 +0800 Cai Huoqing wrote:
> On 28 10=E6=9C=88 22 08:56:51, Jakub Kicinski wrote:
> > > if the cmd is not added to 'nic_cmd_support_vf',
> > > the PF will return false, and the error messsage "PF Receive VFx
> > > unsupported cmd x" in the function 'hinic_mbox_check_cmd_valid',
> > > then, the configuration will not be set to hardware. =20
> >=20
> > You're describing the behavior before the patch?
> >=20
> > After the patch the command is ignored silently, like I said, right?
> > Because there is no handler added to nic_vf_cmd_msg_handler[].
> > Why is that okay? Or is there handler somewhere else? =20
>=20
> No need to add handlers to nic_vf_cmd_msg_handler[].
> It will run the path,
> if (i =3D=3D ARRAY_SIZE(nic_vf_cmd_msg_handler))
> 	err =3D hinic_msg_to_mgmt(&pfhwdev->pf_to_mgmt, HINIC_MOD_L2NIC,
> 				cmd, buf_in, in_size, buf_out,
> 				out_size, HINIC_MGMT_MSG_SYNC);

Meaning it just forwards it to the firmware?

> right? or if not please show the related code.

I don't know, I don't know this random driver. I'm just asking you
questions because as the author of the patch _you_ are supposed to know.
