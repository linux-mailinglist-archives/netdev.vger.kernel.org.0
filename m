Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A720F6D3BD5
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 04:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbjDCCf0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 2 Apr 2023 22:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjDCCfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 22:35:25 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6C0AF1C;
        Sun,  2 Apr 2023 19:35:23 -0700 (PDT)
Received: from dggpeml500018.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PqZfQ6KdYznZTZ;
        Mon,  3 Apr 2023 10:31:58 +0800 (CST)
Received: from dggpeml500019.china.huawei.com (7.185.36.137) by
 dggpeml500018.china.huawei.com (7.185.36.186) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 3 Apr 2023 10:35:21 +0800
Received: from dggpeml500019.china.huawei.com ([7.185.36.137]) by
 dggpeml500019.china.huawei.com ([7.185.36.137]) with mapi id 15.01.2507.023;
 Mon, 3 Apr 2023 10:35:21 +0800
From:   michenyuan <michenyuan@huawei.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     "isdn@linux-pingi.de" <isdn@linux-pingi.de>,
        "marcel@holtmann.org" <marcel@holtmann.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "luiz.dentz@gmail.com" <luiz.dentz@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cmtp: fix argument error
Thread-Topic: [PATCH] cmtp: fix argument error
Thread-Index: Adll1MciwMdgoDOLek2T0qfWz++fNA==
Date:   Mon, 3 Apr 2023 02:35:21 +0000
Message-ID: <9b58282ff4ed4d2daad72539466c685d@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.184.199]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you for your suggestion.

This bug may not cause serious security problem. Function 'bt_sock_unregister' takes its parameter as an index and nulls the corresponding element of 'bt_proto' which is an array of pointers. When 'bt_proto' dereferences each element, it would check whether the element is empty or not. Therefore, the problem of null pointer deference does not occur.

This bug is observed by manually code review.

----------

On Fri, Mar 31, 2023 at 02:45:20PM +0800, Chenyuan Mi wrote:
> Fix this issue by using BTPROTO_CMTP as argument instead of BTPROTO_HIDP.

Thanks for your patch. Some things you may want to consider:

* I think it would be good to describe what the effect of this problem is,
  if it can be observed. And if not, say so. I think it would
  also be useful to state how the problem was found. F.e. using a tool, or
  by inspection.

* As this is described as a fix, it should probably have a fixes tag.
  I think it would be:

Fixes: 8c8de589cedd ("Bluetooth: Added /proc/net/cmtp via bt_procfs_init()")
> Signed-off-by: Chenyuan Mi <michenyuan@huawei.com>
> ---
>  net/bluetooth/cmtp/sock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Code change looks good.

> diff --git a/net/bluetooth/cmtp/sock.c b/net/bluetooth/cmtp/sock.c 
> index 96d49d9fae96..cf4370055ce2 100644
> --- a/net/bluetooth/cmtp/sock.c
> +++ b/net/bluetooth/cmtp/sock.c
> @@ -250,7 +250,7 @@ int cmtp_init_sockets(void)
>  	err = bt_procfs_init(&init_net, "cmtp", &cmtp_sk_list, NULL);
>  	if (err < 0) {
>  		BT_ERR("Failed to create CMTP proc file");
> -		bt_sock_unregister(BTPROTO_HIDP);
> +		bt_sock_unregister(BTPROTO_CMTP);
>  		goto error;
>  	}
>  
> --
> 2.25.1
