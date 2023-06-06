Return-Path: <netdev+bounces-8326-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12EE2723B37
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:19:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3837B2814FB
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 08:19:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A9B928C23;
	Tue,  6 Jun 2023 08:19:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703315660
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 08:19:27 +0000 (UTC)
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7C5E48
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 01:19:24 -0700 (PDT)
X-QQ-mid:Yeas49t1686039488t956t05680
Received: from 3DB253DBDE8942B29385B9DFB0B7E889 (jiawenwu@trustnetic.com [122.235.137.64])
X-QQ-SSF:00400000000000F0FPF000000000000
From: =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 11566667794535501369
To: "'Simon Horman'" <horms@kernel.org>,
	"'Jakub Kicinski'" <kuba@kernel.org>,
	"'David S. Miller'" <davem@davemloft.net>,
	"'Eric Dumazet'" <edumazet@google.com>,
	"'Paolo Abeni'" <pabeni@redhat.com>
Cc: "'Mengyuan Lou'" <mengyuanlou@net-swift.com>,
	"'Dan Carpenter'" <dan.carpenter@linaro.com>,
	<netdev@vger.kernel.org>
References: <20230605-txgbe-wake-v1-1-ea6c441780f9@kernel.org>
In-Reply-To: <20230605-txgbe-wake-v1-1-ea6c441780f9@kernel.org>
Subject: RE: [PATCH net-next] net: txgbe: Avoid passing uninitialised parameter to pci_wake_from_d3()
Date: Tue, 6 Jun 2023 16:18:07 +0800
Message-ID: <01ec01d9984f$6cbfae80$463f0b80$@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: zh-cn
Thread-Index: AQJRnfZAnA4lKC8V2U9yP4hXkWK4hK6NYEnw
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Monday, June 5, 2023 10:20 PM, Simon Horman wrote:
> txgbe_shutdown() relies on txgbe_dev_shutdown() to initialise
> wake by passing it by reference. However, txgbe_dev_shutdown()
> doesn't use this parameter at all.
> 
> wake is then passed uninitialised by txgbe_dev_shutdown()
> to pci_wake_from_d3().
> 
> Resolve this problem by:
> * Removing the unused parameter from txgbe_dev_shutdown()
> * Removing the uninitialised variable wake from txgbe_dev_shutdown()
> * Passing false to pci_wake_from_d3() - this assumes that
>   although uninitialised wake was in practice false (0).
> 
> I'm not sure that this counts as a bug, as I'm not sure that
> it manifests in any unwanted behaviour. But in any case, the issue
> was introduced by:

Thanks for the fix. These are some redundant codes for a feature that has
not yet been implemented.
Reviewed-by: Jiawen Wu <jiawenwu@trustnetic.com>

> 
>   bbd22f34b47c ("net: txgbe: Avoid passing uninitialised parameter to pci_wake_from_d3()")
> 
> Flagged by Smatch as:
> 
>   .../txgbe_main.c:486 txgbe_shutdown() error: uninitialized symbol 'wake'.
> 
> No functional change intended.
> Compile tested only.
> 
> Signed-off-by: Simon Horman <horms@kernel.org>
> ---
>  drivers/net/ethernet/wangxun/txgbe/txgbe_main.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
> index 0f0d9fa1cde1..cfe47f3d2503 100644
> --- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
> +++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
> @@ -457,7 +457,7 @@ static int txgbe_close(struct net_device *netdev)
>  	return 0;
>  }
> 
> -static void txgbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
> +static void txgbe_dev_shutdown(struct pci_dev *pdev)
>  {
>  	struct wx *wx = pci_get_drvdata(pdev);
>  	struct net_device *netdev;
> @@ -477,12 +477,10 @@ static void txgbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
> 
>  static void txgbe_shutdown(struct pci_dev *pdev)
>  {
> -	bool wake;
> -
> -	txgbe_dev_shutdown(pdev, &wake);
> +	txgbe_dev_shutdown(pdev);
> 
>  	if (system_state == SYSTEM_POWER_OFF) {
> -		pci_wake_from_d3(pdev, wake);
> +		pci_wake_from_d3(pdev, false);
>  		pci_set_power_state(pdev, PCI_D3hot);
>  	}
>  }
 


