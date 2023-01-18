Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5177671892
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 11:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjARKIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 05:08:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjARKIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 05:08:32 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2115.outbound.protection.outlook.com [40.107.96.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13576656FD;
        Wed, 18 Jan 2023 01:14:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Af55KP02zbMt8XOXohuJIgkYXpj87Ga0TcoYNSHSLPUEjegc1nTf3SvARJide2IQow+ZEREJo7IooD8QTeFb+BgBrCU57dVlcTP107DptnopQlpafJx8SbqXE9pzc3gqObJ6bfkPRZHu/2Hqw/l/5qnSssUu+XL1DSuCaK0tTpuOIMnV58aFsM0HZ5ug8351/ioaitLuww0w6t6iTL8xEx2AvszI0iAPSLZnqfmmrcmGlRlkG20OSbO+HvidTfXYoVWmGayKbnpHOkeBxlCkHjSfp03bjq1QMRsCx02+GIryxYVtKejoPVYw4kaaPXow0sml1hpF4LX3G5s85UcTkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ruvWeVjNDtmxA2IkxcOHD8Tt7BSEY5ZScBDbF5YJHQA=;
 b=BbHTB8iWLOzOWHnJ+vWj5sSfEhMladhMivWi1PeW2M24jrQkV2K1aEkKPNxAVS7RUW4KwfgOUBxUcCAcEl7EHdljcJc+CK/8Gb/+6yCyi2sPpPjJZgeVkd5RhjuGZQkFUtwKkYFAUzC0WiCipbNNOIicMcqZASF2p55BPbuHMzBN9hq72Y+7xo+VXtj7ERnyidEcYlfnbYIbd2oYQQXj1/zpTyCNFlg9ukdXoKx8FZcmpBCLMJQQEl8kFIqzXbrPEHC2lZu+vDi3aAfnATpxD4SObklNH5ITvPDZjYOkELimWOZfywAPFHH3q0nhDb44HYFUyZSlHTwWNlEup/ujnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ruvWeVjNDtmxA2IkxcOHD8Tt7BSEY5ZScBDbF5YJHQA=;
 b=SkXMotBq/ADwYTncXZnuelXBYAYfNpLOL31eLnfd47PnWCBaAmGfSy9qOQRvxGQUSzAOks0opt3Gor4NitOGs5QKrJ1Szjd7ppriPtCvXUe56+Xq/K7dpAuqAV35JmgB8c4oLogG1fcEoGvp3IlmVOEmhET4jyy92o5dlHOPXRY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB5028.namprd13.prod.outlook.com (2603:10b6:a03:360::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 18 Jan
 2023 09:14:19 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 09:14:19 +0000
Date:   Wed, 18 Jan 2023 10:14:12 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Doug Brown <doug@schmorgal.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dan Williams <dcbw@redhat.com>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 2/4] wifi: libertas: only add RSN/WPA IE in
 lbs_add_wpa_tlv
Message-ID: <Y8e4ZB0YzaF6sLuX@corigine.com>
References: <20230116202126.50400-1-doug@schmorgal.com>
 <20230116202126.50400-3-doug@schmorgal.com>
 <Y8ZjeKeNx0eHxt7f@corigine.com>
 <85128345-4924-c1c9-85f0-7aebc4e40f93@schmorgal.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85128345-4924-c1c9-85f0-7aebc4e40f93@schmorgal.com>
X-ClientProxiedBy: AM0PR06CA0096.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::37) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB5028:EE_
X-MS-Office365-Filtering-Correlation-Id: 67ad761e-c9b9-4b08-8a3e-08daf93460fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: isJpCpM1UjnGcyIvNy/ybtHadzZpKy+cH2j4SP7rSc5rmswYDhbhPw+uRMgs3XZnuDbtmt9574B+pdXNWZSz8wm963iBCN7kWwVr2Zg7n3UXeAm5dv/IsEbvLsiEJsbIe8npKzZ8mOrK6frYeus8vVeGTyA/Ln0lCxBd7y+i+k0+/YfxZlnLsabjEws+R0w5RKFDenXiIEKdZHdOW7ErhTt4ldIw8MpSHRo7S04yfGU3jQiVjzUUbVjJmr7oHNbMz6X/bXSVTayp3lTBnJJc41y6oxk4Dmd9AB5R+uaduVSC0gjJPQGtqQAKcFSFf/6rLBZ/OnGiLI2JnQUwhB6ef0mZFO7C4XVTaG+ew+kGNl2DrdfOOcHA6/0sDEXVigb8pwDPSsN5qHuU6dn/TIB/eCIHZeK+YHE2G2b2I8wh4oHXZu0ivHbOQzIMgKZ09AAsMU/xOdS8RWAFyWasBTMKafJjeGjrH2DaoDr7XiQw6y66wliqMVbq+Cs0Rui7OFdSM5vqnXSZy4ZCm+D4dpxjoRKZ48K5VbI6WwRVEiajvJRzOWMCoFOmcnTepr6DLcc3GIZamgK3sEUWM3OX3Fvz0BsTLJ9hKTRIWe7zxBEQnRiaSChjWXh8ZuZ9N6dY8fM72DUILUCrouhlmajHW7EDb894+ks5JRhjW45RQ49hsd3SEzy/j2LvI5pvjzVYgbPj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(396003)(366004)(39840400004)(451199015)(86362001)(66476007)(2906002)(44832011)(7416002)(66556008)(66946007)(5660300002)(8936002)(38100700002)(316002)(54906003)(6666004)(53546011)(6486002)(6506007)(966005)(478600001)(36756003)(41300700001)(8676002)(4326008)(6916009)(186003)(83380400001)(6512007)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?clvl40sizuFEaQCVKO+1Eot5030XTWV4ptqQL0QJxP92AFhfN0Rxyh5+k4rO?=
 =?us-ascii?Q?TUPwOiu/fjAb8sf/FVOOOC+yar4kuV/JGgFV1qlufGNKoMo1JE7Iz2Wz8MQM?=
 =?us-ascii?Q?ONbQ0DFPqkRxzE4wiWtiUu3PenQLrxqnPaz7KbpfhT/RoDFx3ezv2HpCQd5l?=
 =?us-ascii?Q?+RI+3MoDPp1NYI7WulZOkorEoSf9u2YMqJTISP9NvwUyRABSdetcp02sQwzd?=
 =?us-ascii?Q?UnCkiHvxPFIO1KkxOeZIiAdiBn1XlvFKKAACCmNnp+oBe3e2u+yQ/4EpGZGk?=
 =?us-ascii?Q?Pv0K7wSca2aAhfJ1gjsjc11dQ3hDSvPruDiuccMCGBRvNnLhgpsJsFosnoIW?=
 =?us-ascii?Q?wFD+u9KqJ31X3L4RFpJlJkqob59iam8VNv7OowR4XsKe4pmnd7FY76YCMqjh?=
 =?us-ascii?Q?bDblbeTY19f3m2bA0lfqX3Coifv3MdoKSD4LrW3A6uUcYRA9PB8yQR15aS/u?=
 =?us-ascii?Q?0n9MwEPJoy+YPrOmwv65i3xdSurEV/whue19qn9cMjkNMPyalwRrwFeuEtJF?=
 =?us-ascii?Q?dGZFHYftN4Pi/J3LU4U/hsNmMzuwkeWyp2cckWAkdaL/hX0Ukg5V8yW4D+fY?=
 =?us-ascii?Q?cvChxtRiD+7iVk2aPWCNt5o23vlWeVNsTr1Gm00smbz26wHQkWozuAtPRZPb?=
 =?us-ascii?Q?VGcnF256B+4ZgSfeq/1iC2V9Uqn2u9IgVB5lzTZ8W1v1Dh6jTuLTh3Vf+ONj?=
 =?us-ascii?Q?XxkggatOs3nAutBE41QzRsWAmC+fToPN4yr5n+m4l/dp3PQ4Wb3F8JawrKuu?=
 =?us-ascii?Q?r/wYZjJl71uii6e4DiBkshRO5YRIkOc76kT91nukPwO3PFXKa12ktYq6VIIg?=
 =?us-ascii?Q?qvVaIXi2G4AnEuG4icDu+jl6JO/MXgb3mje6Eqp9uLnbI1X2XyPSPKcQKqBx?=
 =?us-ascii?Q?SlUrnlyrw3yJKrOEbQfnoYco1Ez8QBfPdcuE72v8DKl9vs9sl3Vd/MLBZ40k?=
 =?us-ascii?Q?15K1tUl68pIn2Itg3qq/jOWYYKhcIZCFM4M6ROj1fGu0OYlAO2A4/ZF+rih0?=
 =?us-ascii?Q?Mhr5ebmRnMnJvWbvSigUwj+iq6lD8R1UmPKiWXawA38BicLAcbaztqESBuCK?=
 =?us-ascii?Q?w9r4c78mGy9C4y+F8XbM3BYgUqIDasi/aIVCpf6oprh8md4bkFaVpc9p6fYd?=
 =?us-ascii?Q?dpVegMnPCWgdJfNqW/D49XB6PUcuWbAr+ATnkQjhnPQH2FSuKcaQKON8pNXI?=
 =?us-ascii?Q?NMYcWZAYGlRvDpIl4AGVlOhfVrqKUTYDoYgvT27TH2r/ziREo23mrLYEhprP?=
 =?us-ascii?Q?QZSZS9AnozQYBrTztxbyLLceiTUrXg2/FFw10WT+nICe7K2irdDTH+fkSYZL?=
 =?us-ascii?Q?gu/4gB0itsEvb69IhS5AZLrMxjUn9VgK3qKnW2DJJhwC+gKkCz26hljUPZ7/?=
 =?us-ascii?Q?VOEpyNFeASznPNKM/SpqpKKJ/l5Nv4IEYtTHXBOn9jIw7TxJAkm8yvo4XFey?=
 =?us-ascii?Q?u9MIOLAwJTc0TIk/9zsFlmU/liX0noh7W6Ly+j0l1mFjtA+OzAqsCZraxRNI?=
 =?us-ascii?Q?YL26lMz8QUdsrfA0jKXWvczZld6vqHB2/qgX1zLewnEE0enzHmQdqum/eS3x?=
 =?us-ascii?Q?rF1YjxbX0Ht/nHo2fucp5Ddxxh5/mY+gBVhmB/aH2pUUVoTGUsq1ORZHOXYB?=
 =?us-ascii?Q?8fxO99ayHP9WZUPG5D5im1MlPkSF6Gzoym6XTCp6CZv7jDwDTCPVDBqHaCar?=
 =?us-ascii?Q?JcKjBQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67ad761e-c9b9-4b08-8a3e-08daf93460fa
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 09:14:18.8731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cLIzMOqD5e3RLBdR4b28ce7SSOrTrhfAXO9cf6hmXHYzmcP2ntYIkz9/kJ6Yo1V9htRYrfkEBLCozjhSPmZuLX2PN9EItXlpO4YVYuB1nJs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB5028
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 10:35:56PM -0800, Doug Brown wrote:
> On 1/17/2023 12:59 AM, Simon Horman wrote:
> > On Mon, Jan 16, 2023 at 12:21:24PM -0800, Doug Brown wrote:
> > > [You don't often get email from doug@schmorgal.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> > > 
> > > The existing code only converts the first IE to a TLV, but it returns a
> > > value that takes the length of all IEs into account. When there is more
> > > than one IE (which happens with modern wpa_supplicant versions for
> > > example), the returned length is too long and extra junk TLVs get sent
> > > to the firmware, resulting in an association failure.
> > > 
> > > Fix this by finding the first RSN or WPA IE and only adding that. This
> > > has the extra benefit of working properly if the RSN/WPA IE isn't the
> > > first one in the IE buffer.
> > > 
> > > While we're at it, clean up the code to use the available structs like
> > > the other lbs_add_* functions instead of directly manipulating the TLV
> > > buffer.
> > > 
> > > Signed-off-by: Doug Brown <doug@schmorgal.com>
> > > ---
> > >   drivers/net/wireless/marvell/libertas/cfg.c | 28 +++++++++++++--------
> > >   1 file changed, 18 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/drivers/net/wireless/marvell/libertas/cfg.c b/drivers/net/wireless/marvell/libertas/cfg.c
> > > index 3e065cbb0af9..3f35dc7a1d7d 100644
> > > --- a/drivers/net/wireless/marvell/libertas/cfg.c
> > > +++ b/drivers/net/wireless/marvell/libertas/cfg.c
> > 
> > ...
> > 
> > > @@ -428,14 +438,12 @@ static int lbs_add_wpa_tlv(u8 *tlv, const u8 *ie, u8 ie_len)
> > >           *   __le16  len
> > >           *   u8[]    data
> > >           */
> > > -       *tlv++ = *ie++;
> > > -       *tlv++ = 0;
> > > -       tlv_len = *tlv++ = *ie++;
> > > -       *tlv++ = 0;
> > > -       while (tlv_len--)
> > > -               *tlv++ = *ie++;
> > > -       /* the TLV is two bytes larger than the IE */
> > > -       return ie_len + 2;
> > > +       wpatlv->header.type = cpu_to_le16(wpaie->id);
> > > +       wpatlv->header.len = cpu_to_le16(wpaie->datalen);
> > > +       memcpy(wpatlv->data, wpaie->data, wpaie->datalen);
> > 
> > Hi Doug,
> > 
> > Thanks for fixing the endiness issues with cpu_to_le16()
> > This part looks good to me now. Likewise for patch 4/4.
> > 
> > One suggestion I have, which is probably taking things to far,
> > is a helper for what seems to be repeated code-pattern.
> > But I don't feel strongly about that.
> 
> Thanks Simon. Is this basically what you're suggesting for a helper?
> 
> static int lbs_add_ie_tlv(u8 *tlvbuf, const struct element *ie, u16 tlvtype)
> {
> 	struct mrvl_ie_data *tlv = (struct mrvl_ie_data *)tlvbuf;
> 	tlv->header.type = cpu_to_le16(tlvtype);
> 	tlv->header.len = cpu_to_le16(ie->datalen);
> 	memcpy(tlv->data, ie->data, ie->datalen);
> 	return sizeof(struct mrvl_ie_header) + ie->datalen;
> }
> 
> And then in the two functions where I'm doing that, at the bottom:
> 
> return lbs_add_ie_tlv(tlv, wpaie, wpaie->id);
> return lbs_add_ie_tlv(tlv, wpsie, TLV_TYPE_WPS_ENROLLEE);
> 
> I could definitely do that to avoid repeating the chunk of code that
> fills out the struct in the two functions. A lot of the other
> lbs_add_*_tlv functions follow a similar pattern of setting up a struct
> pointer and filling out the header, so I don't think it's too crazy to
> just repeat the code twice. On the other hand, the example above does
> look pretty darn clean. I don't feel strongly either way myself.

Hi Doug,

yes, I was thinking about something like that.
And wondering if it might be reused elsewhere (in the same file).

But again, I don't feel strongly about this.
So perhaps it's something to consider in future.
