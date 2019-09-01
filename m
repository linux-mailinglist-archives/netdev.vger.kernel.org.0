Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2358A4ACE
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 19:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbfIARU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 13:20:28 -0400
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:50334 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728840AbfIARU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Sep 2019 13:20:28 -0400
Received: from [192.168.1.41] ([90.126.97.183])
        by mwinf5d07 with ME
        id wHLR200063xPcdm03HLRVb; Sun, 01 Sep 2019 19:20:26 +0200
X-ME-Helo: [192.168.1.41]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 01 Sep 2019 19:20:26 +0200
X-ME-IP: 90.126.97.183
Subject: Re: [PATCH] netlabel: remove redundant assignment to pointer iter
To:     Paul Moore <paul@paul-moore.com>,
        Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190901155205.16877-1-colin.king@canonical.com>
 <CAHC9VhSVKEJ-EBAry5fVN3Ux22occGQ5jxbFBecMsR+q7+UT5A@mail.gmail.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <b03aff72-6e61-e196-e81a-373f50c9fbc9@wanadoo.fr>
Date:   Sun, 1 Sep 2019 19:20:25 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAHC9VhSVKEJ-EBAry5fVN3Ux22occGQ5jxbFBecMsR+q7+UT5A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 01/09/2019 à 18:04, Paul Moore a écrit :
> On Sun, Sep 1, 2019 at 11:52 AM Colin King <colin.king@canonical.com> wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> Pointer iter is being initialized with a value that is never read and
>> is being re-assigned a little later on. The assignment is redundant
>> and hence can be removed.
>>
>> Addresses-Coverity: ("Unused value")
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>   net/netlabel/netlabel_kapi.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
> This patch doesn't seem correct to me, at least not in current form.
> At the top of _netlbl_catmap_getnode() is a check to see if iter is
> NULL (as well as a few other checks on iter after that); this patch
> would break that code.
>
> Perhaps we can get rid of the iter/catmap assignment when we define
> iter, but I don't think this patch is the right way to do it.
>
>> diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
>> index 2b0ef55cf89e..409a3ae47ce2 100644
>> --- a/net/netlabel/netlabel_kapi.c
>> +++ b/net/netlabel/netlabel_kapi.c
>> @@ -607,7 +607,7 @@ static struct netlbl_lsm_catmap *_netlbl_catmap_getnode(
>>    */
>>   int netlbl_catmap_walk(struct netlbl_lsm_catmap *catmap, u32 offset)
>>   {
>> -       struct netlbl_lsm_catmap *iter = catmap;
>> +       struct netlbl_lsm_catmap *iter;
>>          u32 idx;
>>          u32 bit;
>>          NETLBL_CATMAP_MAPTYPE bitmap;
>> --
>> 2.20.1
>

Hi,

'iter' is reassigned a value between the declaration and the NULL test, so removing the first initialization looks good to me.
int  netlbl_catmap_walk(struct  netlbl_lsm_catmap  *catmap,  u32  offset)
{
|

	struct  netlbl_lsm_catmap  *iter  =  catmap;
	u32  idx;
	u32  bit;
	NETLBL_CATMAP_MAPTYPE  bitmap;

	iter  =  _netlbl_catmap_getnode(&catmap,  offset,  _CM_F_WALK,  0);			<-- Here
	if  (iter  ==  NULL)
		return  -ENOENT; This is dead code since commit d960a6184a92 ("netlabel: fix the catmap walking functions") where the call to _netlbl_catmap_getnode has been introduced.

Just my 2c,

CJ|

