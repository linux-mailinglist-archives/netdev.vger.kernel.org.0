Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7AEC44428C
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 14:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbhKCNkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 09:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbhKCNkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 09:40:40 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93408C061714;
        Wed,  3 Nov 2021 06:38:03 -0700 (PDT)
Received: from smtp102.mailbox.org (smtp102.mailbox.org [80.241.60.233])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4Hkns40jk3zQjdM;
        Wed,  3 Nov 2021 14:38:00 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Message-ID: <b2aaf6f7-9f22-926a-963b-cfd0d4fca31d@v0yd.nl>
Date:   Wed, 3 Nov 2021 14:37:53 +0100
MIME-Version: 1.0
Subject: Re: [PATCH] mwifiex: Add quirk to disable deep sleep with certain
 hardware revision
Content-Language: en-US
From:   =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>
References: <20211028073729.24408-1-verdre@v0yd.nl>
 <CA+ASDXOrad3b=b8+vwuF6m3+ZcigVaoJySpDXXZOnC3O8CJBSw@mail.gmail.com>
 <cc7432f4-824a-abe2-e304-5ba019ac8c89@v0yd.nl>
In-Reply-To: <cc7432f4-824a-abe2-e304-5ba019ac8c89@v0yd.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7D3831329
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/3/21 13:25, Jonas Dreßler wrote:
> 
>>
>>> --- a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
>>> +++ b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
>>> @@ -708,6 +708,22 @@ static int mwifiex_ret_ver_ext(struct mwifiex_private *priv,
>>>   {
>>>          struct host_cmd_ds_version_ext *ver_ext = &resp->params.verext;
>>>
>>> +       if (test_and_clear_bit(MWIFIEX_IS_REQUESTING_FW_VEREXT, &priv->adapter->work_flags)) {
>>> +               if (strncmp(ver_ext->version_str, "ChipRev:20, BB:9b(10.00), RF:40(21)", 128) == 0) {
>>
>> Rather than memorize the 128-size array here, maybe use
>> sizeof(ver_ext->version_str) ?
> 
> Sounds like a good idea, yeah.

Nevermind, the reason I did this was for consistency in the
function, right underneath in the same function it also assumes
a fixed size of 128 characters, so I'd rather use the same
length.

>		memcpy(version_ext->version_str, ver_ext->version_str,
>		       sizeof(char) * 128);
>		memcpy(priv->version_str, ver_ext->version_str, 128);

Might be a good idea to #define it as MWIFIEX_VERSION_STR_LENGTH
in fw.h though...
