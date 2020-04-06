Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB0AC19F58C
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 14:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbgDFMGN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 6 Apr 2020 08:06:13 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:52364 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbgDFMGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 08:06:12 -0400
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 47318CECC3;
        Mon,  6 Apr 2020 14:15:45 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] Bluetooth: Simplify / fix return values from tk_request
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <0f0ea237-5976-e56f-cd31-96b76bb03254@roeck-us.net>
Date:   Mon, 6 Apr 2020 14:06:10 +0200
Cc:     Alain Michaud <alainmichaud@google.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        BlueZ <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sonny Sasaka <sonnysasaka@chromium.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <6456552C-5910-4D77-9607-14D9D1FA38FD@holtmann.org>
References: <20200403150236.74232-1-linux@roeck-us.net>
 <CALWDO_WK2Vcq+92isabfsn8+=0UPoexF4pxbnEcJJPGas62-yw@mail.gmail.com>
 <0f0ea237-5976-e56f-cd31-96b76bb03254@roeck-us.net>
To:     Guenter Roeck <linux@roeck-us.net>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Guenter,

>>> Some static checker run by 0day reports a variableScope warning.
>>> 
>>> net/bluetooth/smp.c:870:6: warning:
>>>        The scope of the variable 'err' can be reduced. [variableScope]
>>> 
>>> There is no need for two separate variables holding return values.
>>> Stick with the existing variable. While at it, don't pre-initialize
>>> 'ret' because it is set in each code path.
>>> 
>>> tk_request() is supposed to return a negative error code on errors,
>>> not a bluetooth return code. The calling code converts the return
>>> value to SMP_UNSPECIFIED if needed.
>>> 
>>> Fixes: 92516cd97fd4 ("Bluetooth: Always request for user confirmation for Just Works")
>>> Cc: Sonny Sasaka <sonnysasaka@chromium.org>
>>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>>> ---
>>> net/bluetooth/smp.c | 9 ++++-----
>>> 1 file changed, 4 insertions(+), 5 deletions(-)
>>> 
>>> diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
>>> index d0b695ee49f6..30e8626dd553 100644
>>> --- a/net/bluetooth/smp.c
>>> +++ b/net/bluetooth/smp.c
>>> @@ -854,8 +854,7 @@ static int tk_request(struct l2cap_conn *conn, u8 remote_oob, u8 auth,
>>>        struct l2cap_chan *chan = conn->smp;
>>>        struct smp_chan *smp = chan->data;
>>>        u32 passkey = 0;
>>> -       int ret = 0;
>>> -       int err;
>>> +       int ret;
>>> 
>>>        /* Initialize key for JUST WORKS */
>>>        memset(smp->tk, 0, sizeof(smp->tk));
>>> @@ -887,12 +886,12 @@ static int tk_request(struct l2cap_conn *conn, u8 remote_oob, u8 auth,
>>>        /* If Just Works, Continue with Zero TK and ask user-space for
>>>         * confirmation */
>>>        if (smp->method == JUST_WORKS) {
>>> -               err = mgmt_user_confirm_request(hcon->hdev, &hcon->dst,
>>> +               ret = mgmt_user_confirm_request(hcon->hdev, &hcon->dst,
>>>                                                hcon->type,
>>>                                                hcon->dst_type,
>>>                                                passkey, 1);
>>> -               if (err)
>>> -                       return SMP_UNSPECIFIED;
>>> +               if (ret)
>>> +                       return ret;
>> I think there may be some miss match between expected types of error
>> codes here.  The SMP error code type seems to be expected throughout
>> this code base, so this change would propagate a potential negative
>> value while the rest of the SMP protocol expects strictly positive
>> error codes.
>> 
> 
> Up to the patch introducing the SMP_UNSPECIFIED return value, tk_request()
> returned negative error codes, and all callers convert it to SMP_UNSPECIFIED.
> 
> If tk_request() is supposed to return SMP_UNSPECIFIED on error, it should
> be returned consistently, and its callers don't have to convert it again.

maybe we need to fix that initial patch then.

Regards

Marcel

