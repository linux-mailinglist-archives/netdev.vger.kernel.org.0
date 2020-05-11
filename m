Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971E91CD5AE
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 11:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729470AbgEKJuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 05:50:10 -0400
Received: from mail-eopbgr80052.outbound.protection.outlook.com ([40.107.8.52]:60750
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728209AbgEKJuK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 05:50:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GVsuie6WOFwlO3XwUilhv/ZCGkhzigzF1ojGdFV4NJBQ+j8sNkKez/mG8pThRRxJ+08dulFNYHHZ2FXBRCsNdnacZJ95VDFFMli3iLCHv6m0Af+hcggOS1KAdA39Sf2MyLEIiqA4GlELqMBSdnMVOihyt55HkOhlbfpt0sxX0jolLhSjE46gZIFhQeqCv1ilCqMkLEWz6Goo98enrjPZCBQtpf7YR5qo1Mx5YJoVmua/M7VVLMl779Pvgu+mfo1xAyp0x+gt5hEwfo776uShpqjYgByOpvmVpFoo8L+52tKHfIlvRK4JNnZIqFvLfHWNx9fE94kvrrmwrvalNBAe2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B3CzadvEI85dxrb5Xp29oi/KlXAwcWN+ctGNOggEvos=;
 b=H+M75ybvLcXjptMoSnqbnE5kBJ3yD2z0y/wC/0eINsZxMHIN8c/X59/wEh4Jpa3nQ2UT0jIFGPHD71K+CLNuIf0x0Z/kF3L5EgC8MCBA0pk025Y5uPYPoNUxbRH8Bhl7IbcwpEMO5UY6XiJimVz3LlHm54kkeRc/G2P2TdKGW4Qp/78v1GQ+wUS/lMED26wN57qP/E2St7ihxMOkIaknYJk2zCmtAZO89Z0LFLubvhwhHULVR0EGo3jytqPeJ0uSCjnkPIVoWJGRa61n1IQZ82QepOkJABlABEvx+xQmhznUCwuew3Yl4lZq06aHZhtwiiOc6VhGW5ABRJ3XW5pi4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B3CzadvEI85dxrb5Xp29oi/KlXAwcWN+ctGNOggEvos=;
 b=Xj8B2K/k6eTC0ZSJ6rqORZnUu4lCXArCfq18N2KtunSydHQ5kpSjNeO+/7PGqptORy9p1UblXnzvgy/W9BzWk3kiaf1QopAFBRJPoSIrkKvQ0HyMeToMcYgIOID0Y2qEvxMyAP4PKNvkMaSPwCzihFaWPs3Q6464AcFb0bZUPVU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (2603:10a6:20b:11::14)
 by AM6PR05MB5733.eurprd05.prod.outlook.com (2603:10a6:20b:29::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.33; Mon, 11 May
 2020 09:50:07 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::f5bd:86c3:6c50:6718]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::f5bd:86c3:6c50:6718%7]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 09:50:07 +0000
Subject: Re: [PATCH net] netfilter: flowtable: Fix expired flow not being
 deleted from software
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Oz Shlomo <ozsh@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        netfilter-devel@vger.kernel.org
References: <1588764449-12706-1-git-send-email-paulb@mellanox.com>
 <20200510222640.GA11645@salvia>
 <a420c22a-9d52-c314-cf9b-ee19831e15a7@mellanox.com>
 <20200511084243.GA18188@salvia>
From:   Paul Blakey <paulb@mellanox.com>
Message-ID: <b3a54d5e-bb00-3306-c064-5c85806560e1@mellanox.com>
Date:   Mon, 11 May 2020 12:50:02 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
In-Reply-To: <20200511084243.GA18188@salvia>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM3PR04CA0135.eurprd04.prod.outlook.com (2603:10a6:207::19)
 To AM6PR05MB5096.eurprd05.prod.outlook.com (2603:10a6:20b:11::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.50.62] (5.29.240.93) by AM3PR04CA0135.eurprd04.prod.outlook.com (2603:10a6:207::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Mon, 11 May 2020 09:50:06 +0000
X-Originating-IP: [5.29.240.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b4b7d5e2-d4da-45f7-6a28-08d7f590afa7
X-MS-TrafficTypeDiagnostic: AM6PR05MB5733:|AM6PR05MB5733:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB57339224559F18CBEE66B7B6CFA10@AM6PR05MB5733.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VGyXo9kZyyYuiborc8xRZ1kv6RXs91Xfa3/arnC3JbGpZTGxwTRAhcmriwxw8PVDcwdQhWkARuPHlqVf0XSQdcve8YwDYE8IXMmffgOF+PzI85acq8K15sGKkP5t2z0peY+JZg1Aqg56cHH+5brcIu3E2BJlCa31+KZXGm6UiQkaH9zRFIS+xOjq8YDqG7JdfAUT8qLOtOWGEmjT/Ad+9l1b30+6fdp8XJ6biZtyEcfAlZrwdW4n9shH6bBYgKJYhwtyB+STF2WoGaPc5hps+6Xv4vNBYWyTsBftjW6ZAWbU/hyaZV1kPi9jmVy50szfKzKQvNK5GfDDS1+SOJGPoGCYNYA93IdeOUw8I0jggTCNU1xdoAQ4Q4MYMzqmtDQKL8ggxcwrGL/Dgq8fFeBEmUhsGWLaQdZBd1pDBF/TOAbu09bdpBQ92VX7TQSjB0mgyivcQ/g9DoMKRZpF4Ik+yQsI0WXfVrKU8TOORQMosdIy/aK8kVPEKloq5D0lBILvMdmB1/48DHgGptcexpNBcXh9jDdzdJsPw/HwtvJy3Ni4ihVyaihRACfnGdSFi28Z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5096.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(136003)(346002)(366004)(376002)(33430700001)(52116002)(33440700001)(6486002)(6666004)(5660300002)(4326008)(31696002)(478600001)(86362001)(31686004)(2616005)(6916009)(956004)(8936002)(2906002)(36756003)(8676002)(53546011)(66476007)(66556008)(66946007)(186003)(16526019)(26005)(316002)(16576012)(54906003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: PKdBUJipXaOVQ0sOnarp8/m5qv2KE347NbEY/DsM4vs+mMfQor0sWvq5w6kWhpJa2TupPiB42A4+8m07zKAAry/AJ+BscUBhfWykPRGoCPixPjErg6TSeu4npfoQvp1m9T6Wru17kGB3xPtM5Qxl7He1aZGPlwnLaAMXkd/fZ6Oj1B1J617jdMqmt+elToOhQiAUGwMfISgtNerYjzTHqb0k8vQfAknbKHxNuo1uSNoflfM6RnB4689ABbrEeTt7U+Zf/OBPmDya1WPrd7W9GH9Sg3pxoZdNkZEI+qYhOUY/8LaKi90kH4dtYPAHUzq2jNg5qbpWt7gbAfGFIwQxmd8dHAccYbLzTOMwVcB0JRe3+MRk0nZrsR9K0tK5Ku8dWTvvlaL/ps1y0r/DdUjpm01IoxdFZ2S+u/hu2rGrcOxTh1QsVbICHFw4OM996+nXwelbw07JclqE0nLyjJAnx16Ol+RPW6WmT5s89qh7T/E=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4b7d5e2-d4da-45f7-6a28-08d7f590afa7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 09:50:06.9343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tIZTLUFnm3mTtb4yFGRWaj7LFtXWP+Utyd0oVkBch8SMvqWfnsjyRlizMTah2de23ev83f9n6vVCGGsj/0Iw3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5733
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/2020 11:42 AM, Pablo Neira Ayuso wrote:
> On Mon, May 11, 2020 at 10:24:44AM +0300, Paul Blakey wrote:
>>
>> On 5/11/2020 1:26 AM, Pablo Neira Ayuso wrote:
>>> On Wed, May 06, 2020 at 02:27:29PM +0300, Paul Blakey wrote:
>>>> Once a flow is considered expired, it is marked as DYING, and
>>>> scheduled a delete from hardware. The flow will be deleted from
>>>> software, in the next gc_step after hardware deletes the flow
>>>> (and flow is marked DEAD). Till that happens, the flow's timeout
>>>> might be updated from a previous scheduled stats, or software packets
>>>> (refresh). This will cause the gc_step to no longer consider the flow
>>>> expired, and it will not be deleted from software.
>>>>
>>>> Fix that by looking at the DYING flag as in deciding
>>>> a flow should be deleted from software.
>>> Would this work for you?
>>>
>>> The idea is to skip the refresh if this has already expired.
>>>
>>> Thanks.
>> The idea is ok, but timeout check + update isn't atomic (need atomic_inc_unlesss
>> or something like that), and there is also
>> the hardware stats which if comes too late (after gc finds it expired) might
>> bring a flow back to life.
> Right. Once the entry has expired, there should not be a way turning
> back.
>
> I'm attaching a new sketch, it's basically using the teardown state to
> specify that the gc already made the decision to remove this entry.
>
> Thanks.

Looks fine to me, are you submitting that instead?

