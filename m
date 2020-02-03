Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8CC15092D
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 16:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728661AbgBCPJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 10:09:06 -0500
Received: from mail-co1nam11on2041.outbound.protection.outlook.com ([40.107.220.41]:6266
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727988AbgBCPJG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 10:09:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bFbT42sMFRY7vyR2jsg+vU861J73ShTeCYxIeU7+UOMEX77sOrClFHi9SDo2lfCqCRGe2cnkI9PUrjVOgkxM60kbN0xkW2QJNKGd1Jn4fXtoO72gCnLKaxC+LjGC/2VtQplrm23KjVETjmOL1MsZaH99Fw9XnfeOFRiiEQJmsZ5VfejtQwOZyuwK+N1kdt98nl+u5QXdaXDiHUejF92+Pv1qUjtgSK3nqSuNCXsm0l/g2dEPWW+UNd5mA2DyKwuO2tSmHiuc/W0F2rpykyDZRuMr+HR+FIqDv+Pfk88zoscgGzAPbqvVmMYLq60j8c2pm9j9TW4IesBXvGenzLeb7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mDPxitvLu7tX2qnG6XHJ2l592m0cADpHtKPko8YQ3Bs=;
 b=EhoXJC4wpGIj+FfvX09YRSfw3h5OkN59SeUw99sXtQC346rl8LWJKG7oF6Hpxjr2BqlW93U9KCEvMLZmRFQguB+99tWwHbdiz2sZPsdSe6een6wxsjjw+Vhxv/57otApg9djMq7SfChNEvFx7VVIGTU6myWNp6WL8Po98BcuUiYJ3LOp8NRjrQeJOWzO/c/mhPr/RWNZBeqJViJHNx1BZ0+p7o/h73CXCfhk4bP40weod5bhuBSrrBmeyOA8YZ8dUKoDLA/0p7ZtGaBjIKeYw1ylC4OWgrRToZQ1lnm3NLBnsLaATYCMNdoN5aMdfAOb0WRcmvqrXa2jGJhtgnandw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mDPxitvLu7tX2qnG6XHJ2l592m0cADpHtKPko8YQ3Bs=;
 b=nvgi5GcbStbtbT6MhsY4R4jdQh6fKkjZtyQWhiVqR5ntAiDc2LWCwgaqo/QRWFzpn0VodUEK+EFaUiDeHYfFUHh6W4ptY1gcc8uN+jxbYYfAT7fUaYDZF0BbRzBns5LbGO7vzypW1U2nQT4/427VmEweEjswpA9faWePIZ5J+Z0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Christian.Koenig@amd.com; 
Received: from DM5PR12MB1705.namprd12.prod.outlook.com (10.175.88.22) by
 DM5PR12MB1129.namprd12.prod.outlook.com (10.168.240.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.32; Mon, 3 Feb 2020 15:09:00 +0000
Received: from DM5PR12MB1705.namprd12.prod.outlook.com
 ([fe80::d40e:7339:8605:bc92]) by DM5PR12MB1705.namprd12.prod.outlook.com
 ([fe80::d40e:7339:8605:bc92%11]) with mapi id 15.20.2686.031; Mon, 3 Feb 2020
 15:09:00 +0000
Subject: Re: KASAN: use-after-free Read in vgem_gem_dumb_create
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Daniel Vetter <daniel@ffwll.ch>
Cc:     syzbot <syzbot+0dc4444774d419e916c8@syzkaller.appspotmail.com>,
        Dave Airlie <airlied@linux.ie>,
        Alex Deucher <alexander.deucher@amd.com>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        "Wilson, Chris" <chris@chris-wilson.co.uk>,
        David Miller <davem@davemloft.net>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Emil Velikov <emil.velikov@collabora.com>,
        "Anholt, Eric" <eric@anholt.net>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK" 
        <linaro-mm-sig@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Rob Clark <robdclark@chromium.org>,
        Sean Paul <seanpaul@chromium.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
References: <000000000000ae2f81059d7716b8@google.com>
 <CAKMK7uGivsYzP6h9rg0eN34YuOVbee6gnhdOxiys=M=4phK+kw@mail.gmail.com>
 <20200203090619.GL1778@kadam>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <7ba76c48-a002-12c3-8114-701e399b1190@amd.com>
Date:   Mon, 3 Feb 2020 16:08:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <20200203090619.GL1778@kadam>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM4PR05CA0005.eurprd05.prod.outlook.com (2603:10a6:205::18)
 To DM5PR12MB1705.namprd12.prod.outlook.com (2603:10b6:3:10c::22)
MIME-Version: 1.0
Received: from [IPv6:2a02:908:1252:fb60:be8a:bd56:1f94:86e7] (2a02:908:1252:fb60:be8a:bd56:1f94:86e7) by AM4PR05CA0005.eurprd05.prod.outlook.com (2603:10a6:205::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.27 via Frontend Transport; Mon, 3 Feb 2020 15:08:57 +0000
X-Originating-IP: [2a02:908:1252:fb60:be8a:bd56:1f94:86e7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 365c22ee-84fd-4d7b-d8ba-08d7a8baffc3
X-MS-TrafficTypeDiagnostic: DM5PR12MB1129:|DM5PR12MB1129:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB112930A95A172964ADD1FFD983000@DM5PR12MB1129.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0302D4F392
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10001)(10009020)(4636009)(396003)(376002)(366004)(136003)(39860400002)(346002)(189003)(199004)(45080400002)(478600001)(186003)(16526019)(66946007)(6486002)(966005)(6666004)(53546011)(7416002)(2906002)(54906003)(31696002)(110136005)(86362001)(4326008)(316002)(52116002)(81156014)(31686004)(66556008)(66476007)(81166006)(2616005)(36756003)(8676002)(8936002)(5660300002)(99710200001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1129;H:DM5PR12MB1705.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tTNPf+FzOYMVATiqEOY3aDFPauPiAn7KMNMGfQ2Z5DvCSYrnWPXHZ/5PmkjfBrpsesgsdDkiW6H3F1v188Ak49K6jXD7csXYXqEoB40TmF2Edt52F56nMjk/IXpmUssloF5hSuSLlJcbZoyGfk1b/QD9WKaO0+Nc3fVuDj0rAWBBSsJLo1yws5YKXgxFgUwfKvtleIsUUagGtdrGu7p+4keDZ78oSxRPUBsJEz2wl0wgfVTIfK3yIUMY97qw3Mov7Rq0PRgwKBbv+TejRSm5QoV04LWlzW0cN4Nn0ODHCaR2wrO/nala6C6Lgvuo+7yohRTqcRfZgHIC0tS0oSAz7QS8NEEgw0oRw4heRf6qoEQSt3fugZC5eRXoU6krBwbKmgCziNedlOoC/A8QxmmQof1LGbyx8wiKe/rGXOTpvEthUvgTDzc/OSwDUcpaN46XXWKYzcVitehx0XeIy865Z4LrN1bZEXFyUJdoQ6AcLa78lV5E/g0EbQOfkDnA8JfwJK+4ajTuGSG3pUrcdYBoaDCSTiSubGFKXOl6T0WW8LEnqUspXDsjvcHApjIOmtZPvfjLQZgn9G0sqWRGgbqM1BznkFMici1Q4c9rY9Aq4BFDgWCFepAEemrVMviKvv8G4BwPrT4Pb/cD8J4fsKATKw==
X-MS-Exchange-AntiSpam-MessageData: BEEKTmWHUNj9YPxqZRt34IaeDjojfLOnibllKiw1hZ7t7HvxZplsXb2CKlaNt44z50sIYKayORMWNYFNnL8YCvREejxF7tzaf6Ot/fC2qKL6nKCgbotLkNVWG3S6ERLyT69WRyxIQ6ds1c299zv2HQI3yL3XkcTBbR41Kd2ky9PN5YFMyJgFGtkni/axItOJh7AG1+2U7uRenS5P3j8/wQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 365c22ee-84fd-4d7b-d8ba-08d7a8baffc3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2020 15:09:00.7031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q8284h64pNXNi3WZvQfc60O+idzZPv7ycBZwMJ+q7dFh5AabbkVgJO08MdI8xfYg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1129
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 03.02.20 um 10:06 schrieb Dan Carpenter:
> On Sun, Feb 02, 2020 at 02:19:18PM +0100, Daniel Vetter wrote:
>> On Fri, Jan 31, 2020 at 11:28 PM syzbot
>> <syzbot+0dc4444774d419e916c8@syzkaller.appspotmail.com> wrote:
>>> Hello,
>>>
>>> syzbot found the following crash on:
>>>
>>> HEAD commit:    39bed42d Merge tag 'for-linus-hmm' of git://git.kernel.org..
>>> git tree:       upstream
>>> console output: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fsyzkaller.appspot.com%2Fx%2Flog.txt%3Fx%3D179465bee00000&amp;data=02%7C01%7Cchristian.koenig%40amd.com%7C529f2273b8374f38560108d7a88862eb%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637163176051177627&amp;sdata=3goGqBs4%2BjkjCeV2bX5VTB%2F1PRLEP5bzq5Ec%2BN7fKHs%3D&amp;reserved=0
>>> kernel config:  https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fsyzkaller.appspot.com%2Fx%2F.config%3Fx%3D2646535f8818ae25&amp;data=02%7C01%7Cchristian.koenig%40amd.com%7C529f2273b8374f38560108d7a88862eb%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637163176051177627&amp;sdata=SnlKln%2FAG%2BVRVjSrOSJjUE%2BhSDf35wTqzWLCAyGQVss%3D&amp;reserved=0
>>> dashboard link: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fsyzkaller.appspot.com%2Fbug%3Fextid%3D0dc4444774d419e916c8&amp;data=02%7C01%7Cchristian.koenig%40amd.com%7C529f2273b8374f38560108d7a88862eb%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637163176051177627&amp;sdata=33EJNAWjTm6Edi1J0oPBfs8epb%2BQ2cpAKlzl1sT40CQ%3D&amp;reserved=0
>>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>>> syz repro:      https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fsyzkaller.appspot.com%2Fx%2Frepro.syz%3Fx%3D16251279e00000&amp;data=02%7C01%7Cchristian.koenig%40amd.com%7C529f2273b8374f38560108d7a88862eb%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637163176051177627&amp;sdata=zmUyyp7znqQfLzzNZ80bNgCILAjeMeCVVr7xf7CHaWk%3D&amp;reserved=0
>>>
>>> The bug was bisected to:
>>>
>>> commit 7611750784664db46d0db95631e322aeb263dde7
>>> Author: Alex Deucher <alexander.deucher@amd.com>
>>> Date:   Wed Jun 21 16:31:41 2017 +0000
>>>
>>>      drm/amdgpu: use kernel is_power_of_2 rather than local version
>>>
>>> bisection log:  https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fsyzkaller.appspot.com%2Fx%2Fbisect.txt%3Fx%3D11628df1e00000&amp;data=02%7C01%7Cchristian.koenig%40amd.com%7C529f2273b8374f38560108d7a88862eb%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637163176051177627&amp;sdata=5QpTG4iU%2FOt22L3jxRbNxtVPZZ2EvBAcFGZdqVnVCbU%3D&amp;reserved=0
>>> final crash:    https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fsyzkaller.appspot.com%2Fx%2Freport.txt%3Fx%3D13628df1e00000&amp;data=02%7C01%7Cchristian.koenig%40amd.com%7C529f2273b8374f38560108d7a88862eb%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637163176051177627&amp;sdata=hN6UZnFR2nIMPMspjIF7S82oXstaRl%2BLAzmz5yujPac%3D&amp;reserved=0
>>> console output: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fsyzkaller.appspot.com%2Fx%2Flog.txt%3Fx%3D15628df1e00000&amp;data=02%7C01%7Cchristian.koenig%40amd.com%7C529f2273b8374f38560108d7a88862eb%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637163176051177627&amp;sdata=LHXMANOURDv3EsqTSvHSBZnPEzGQoJU1RbeqYExCaGk%3D&amp;reserved=0
>>>
>>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>>> Reported-by: syzbot+0dc4444774d419e916c8@syzkaller.appspotmail.com
>>> Fixes: 761175078466 ("drm/amdgpu: use kernel is_power_of_2 rather than local version")
>> Aside: This bisect line is complete nonsense ... I'm kinda at the
>> point where I'm assuming that syzbot bisect results are garbage, which
>> is maybe not what we want. I guess much stricter filtering for noise
>> is needed, dunno.
>> -Danile
> With race conditions the git bisect is often nonsense.

Which makes sense, but we can still try to sanitize the result. I'm not 
familiar with the test case, but I think it doesn't even compile the 
amdgpu driver.

So skipping all patches of stuff you don't even compile would make not 
only the result of bisecting quite a bit more reliable, but also speed 
the process up quite a bit.

But no good idea to how teach that to a compile bot or the git bisect 
command.

Regards,
Christian.

>
> regards,
> dan carpenter
>

