Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 233D023E87B
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 10:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgHGIEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 04:04:06 -0400
Received: from mail-db8eur05on2108.outbound.protection.outlook.com ([40.107.20.108]:23136
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725805AbgHGIEF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Aug 2020 04:04:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hd/Iy1mldcqukiNmT7Dn/gt90PL+yW1i7aMK2AH8BOp3CGfZKRH5fj+xi6gZ4RiSZC7ubwxF5Y4OvHdQwc82+WyTtSfYrqSeI65Gt8lhsUrJaR+YMYveKMy0IVPDEeNaCCq+ukK+2AIWe1ZbeUKGpap+KYLeRERLSthgye3FSA+WdcrMJ3Nd4NnUPxDi/Fw702w/VYD55b2UawmrI43ECjSb/B3CL8A/LJw1ABaH+S3lTo8UNDhTNk/wE+aaiXo1ohSiOsoRIONFS5mCAwhRd1HlM7MMxZpWMVQg8yDRkadHPDra0E9FZ4JfoqI36uBMjHSVZlf69MvqwqacwN+Ytw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AbcNxCLoviyz3Mb+GBXRlC5cJS24wfjH6/e9R080MFY=;
 b=j4ZHn9EeSDhjyE1O4OaZ61GTFoVLotCGjxj6zXlpf/YxPwVSQorzSIURFOvlluHPPcEnbHM5y5ES5rrv6dU3mELbXSCrznmbhinnGUP1d3aqhIvtAxKyhAaDiLh/K6bcUyD9hl2cdCtsP/iGuqXAE7S+L5LLOPMuH4XdlYc6VnnTHsDcYyXrI9rTEzfS+tQNk6SvBL72qUiDPMIkzVZzPG53hY0t2yV4c/3/4RcN9w4mEwoh4YR/YIlKfmNr6vfRc9DoyILoK/rPGj/x8qWovZ0MKBpCPoKZZIZkSXZH6pqQqF13xIYg6DABOVxN77avKRi541h+NhqkC0O9FNRzLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AbcNxCLoviyz3Mb+GBXRlC5cJS24wfjH6/e9R080MFY=;
 b=c68FtCKI0QW0/zcmNjwJRVMZHeIYVO+JKVzPesg4onuGykmIAE1lg3Lgu2sldKvL1jEnO7cIo8lpvvW6u1/c0YfPrmdN8QxC/lq1fhOwacz/q4jyVsCty4f3Bwr3g3mkFdB5hCy2RtAjUSktx/+loWWnl7DXLHZ3UXmAdrta5c8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB2674.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:12a::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.20; Fri, 7 Aug
 2020 08:04:01 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3cfb:a3e6:dfc0:37ec]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3cfb:a3e6:dfc0:37ec%3]) with mapi id 15.20.3261.018; Fri, 7 Aug 2020
 08:04:01 +0000
Subject: Re: rtnl_trylock() versus SCHED_FIFO lockup
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     Network Development <netdev@vger.kernel.org>
References: <b6eca125-351c-27c5-c34b-08c611ac2511@prevas.dk>
 <20200805163425.6c13ef11@hermes.lan>
 <191e0da8-178f-5f91-3d37-9b7cefb61352@prevas.dk>
 <2a6edf25-b12b-c500-ad33-c0ec9e60cde9@cumulusnetworks.com>
 <20200806203922.3d687bf2@hermes.lan>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <29a82363-411c-6f2b-9f55-97482504e453@prevas.dk>
Date:   Fri, 7 Aug 2020 10:03:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200806203922.3d687bf2@hermes.lan>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR10CA0012.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::22) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.16.11.132] (81.216.59.226) by AM0PR10CA0012.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19 via Frontend Transport; Fri, 7 Aug 2020 08:04:00 +0000
X-Originating-IP: [81.216.59.226]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c5a18f7-85a1-4582-729a-08d83aa8719e
X-MS-TrafficTypeDiagnostic: AM0PR10MB2674:
X-Microsoft-Antispam-PRVS: <AM0PR10MB26745E98A287636338D47A2893490@AM0PR10MB2674.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jSs8Y+9jsQYeDhcJrI352qJRAq8BU9rGxF072xLy1X0d8QfciNslxbIErC5ZF2sN+bWgCswkCPBshYQ8Cqe7dS8oBcwE5pIx/rTToiDby9v5l4Dy0A4NJhTMJJv5GUjDx9KmhD3EpVv8kV82P9lDRbC6veCwERgucXY9DCPS/hvkRM0K+0D58gW0QpkRUKxSgdJRtvjov7o92A4QlhKc2HPXdfweGdZDBgZEqlbi3excfwEpYq6RPRC+dEIM8C6aJsq1Xw5IVDx7myKS+3iIiPnNDLqDrgm6sFaA3k74cnepH666fjpO/04RWrvAPMcw1AxP4PWz4+bmU23cVh0+qBjEyBWi3Ngs1gi+kclsHbwaQOJljju2tjGHTPJt3Ruv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(39840400004)(396003)(366004)(376002)(346002)(136003)(83380400001)(31696002)(31686004)(2616005)(956004)(86362001)(44832011)(2906002)(26005)(16576012)(110136005)(8676002)(66946007)(4326008)(66556008)(66476007)(8936002)(8976002)(36756003)(186003)(16526019)(5660300002)(53546011)(52116002)(6486002)(316002)(508600001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: sB3NXcEJ5PpegRsvhzhZ5/UK+47WekLySDXHNygw6MUGvu/hSHnF8u7emOCBgkFwENweZLod5EVgW4tArUDlvkeCpzDH9YGdjEMPw0lkJ8YOos6hRAOuW2aTeM2xx/9rrNOHBEI36Qts+cwM1eFk8QY957qL1IWuw/ZgZQ/HUk/HXdfHEh8+DwpcuDbKN5fwJr7KIP/8mi4h6o8LQwZWrvPzNtk1d/LrXrnZthqSGTAO7iO78F/AKk6NK1tBtbDIzNPQqb527WKxXFiANYbzwhp36LNEr8iUW463cGGODxST25nubyFlj+BLHPGcejBILLOymcWj0U1JxtzBi/D0K8QhonQ+HcVbQ7mYBMz0p5UWzYgLGLh5hN4nPG+XLHqmWeFen80f8sVD7ZCkPTo7c3jVaRqAexxbX+a2QVsqoOvvD0Puuximbb8q4wF6oiRj7qjWBbVCNjhQNCI+UIwr/o1YBo8ua4+zEgfvQ92RDWE8kcz+oMoOAlJrszm0HpYA2oKwlUCfANQWCinfgadNZOz1TND0ViMT9eSdMAPJXGsh09hew+Ry4fgMUSIkGultUrEiei2pMUGyWR+vjlByhOKavtvJjAK7ipx5Fhm7+YHIqRaGzEHZzPLWTrI6adsJzBtORKg2sj04QM0Qeucs5g==
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c5a18f7-85a1-4582-729a-08d83aa8719e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 08:04:01.1249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PaAZtLDfeop880dxptJaT54/kVugPSs/E0eV1mdGJ4R54diO6tQ4tyKFJLQAjWS+QzRjDAfQuTil6IpWA3PAbDkHGl7dPevYcXYe+b832h0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2674
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/08/2020 05.39, Stephen Hemminger wrote:
> On Thu, 6 Aug 2020 12:46:43 +0300
> Nikolay Aleksandrov <nikolay@cumulusnetworks.com> wrote:
> 
>> On 06/08/2020 12:17, Rasmus Villemoes wrote:
>>> On 06/08/2020 01.34, Stephen Hemminger wrote:  
>>>> On Wed, 5 Aug 2020 16:25:23 +0200

>>
>> Hi Rasmus,
>> I haven't tested anything but git history (and some grepping) points to deadlocks when
>> sysfs entries are being changed under rtnl.
>> For example check: af38f2989572704a846a5577b5ab3b1e2885cbfb and 336ca57c3b4e2b58ea3273e6d978ab3dfa387b4c
>> This is a common usage pattern throughout net/, the bridge is not the only case and there are more
>> commits which talk about deadlocks.
>> Again I haven't verified anything but it seems on device delete (w/ rtnl held) -> sysfs delete
>> would wait for current readers, but current readers might be stuck waiting on rtnl and we can deadlock.
>>
> 
> I was referring to AB BA lock inversion problems.

Ah, so lock inversion, not priority inversion.

> 
> Yes the trylock goes back to:
> 
> commit af38f2989572704a846a5577b5ab3b1e2885cbfb
> Author: Eric W. Biederman <ebiederm@xmission.com>
> Date:   Wed May 13 17:00:41 2009 +0000
> 
>     net: Fix bridgeing sysfs handling of rtnl_lock
>     
>     Holding rtnl_lock when we are unregistering the sysfs files can
>     deadlock if we unconditionally take rtnl_lock in a sysfs file.  So fix
>     it with the now familiar patter of: rtnl_trylock and syscall_restart()
>     
>     Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> 
> The problem is that the unregister of netdevice happens under rtnl and
> this unregister path has to remove sysfs and other objects.
> So those objects have to have conditional locking.
I see. And the reason the "trylock, unwind all the way back to syscall
entry and start over" works is that we then go through

kernfs_fop_write()
	mutex_lock(&of->mutex);
	if (!kernfs_get_active(of->kn)) {
		mutex_unlock(&of->mutex);
		len = -ENODEV;
		goto out_free;
	}

which makes the write fail with ENODEV if the sysfs node has already
been marked for removal.

If I'm reading the code correctly, doing "ip link set dev foobar type
bridge fdb_flush" is equivalent to writing to that sysfs file, except
the former ends up doing an unconditional rtnl_lock() and thus won't
have the livelocking issue.

Thanks,
Rasmus
