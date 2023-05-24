Return-Path: <netdev+bounces-4873-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D01A70EEC9
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 09:00:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2C171C209E2
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 07:00:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43AEF6FA5;
	Wed, 24 May 2023 07:00:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316985225
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 07:00:30 +0000 (UTC)
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38144E5D
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 00:00:22 -0700 (PDT)
X-QQ-mid: bizesmtp73t1684911606tp48hdp6
Received: from smtpclient.apple ( [122.235.247.1])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 24 May 2023 15:00:05 +0800 (CST)
X-QQ-SSF: 00400000000000N0Z000000A0000000
X-QQ-FEAT: vLOCICHxEeA4pd+ZdDbOHCBFfQbLXuS9JLbJehvt4K99S6Sb3ydx2S/bAkc4t
	i6ewzkmmiyMD4nNaIUid+4EmgQJsxIyYy8NP6AaxCSp5dphIlqkpxv747/KpRykHNAHkUrA
	ufy2z/eQFajdAJ0G2rOk2DSMztDfH2zPWMVtL8QppF/LpT2jCuFaq97y/jd1X4TQXMiMaO9
	DjEbL2qcFKhHJS4ydajLhElBG8I0LlNdTbT/AEn0yroMNISznIllNHI5jJ3jJ+7IEOzQths
	HeaG1v9kYh4FLUN6OpkUZdmgNF+/lN6dRbbfUQCdwJmuLz2y5j1RAkJJJdoM4RiZ0we0S+Q
	h9LOB7lDzyY6HASLnGL4YiP8+26HOxaNJjpAZ47OPRRgb98a3NskGFQjMzlC6gGVDc6vlN/
	dDcwux5wMhU=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 5448550017033225391
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH net-next v6 1/8] net: wangxun: libwx add tx offload
 functions
From: "mengyuanlou@net-swift.com" <mengyuanlou@net-swift.com>
In-Reply-To: <20230523210659.11304cce@kernel.org>
Date: Wed, 24 May 2023 14:59:54 +0800
Cc: netdev@vger.kernel.org,
 Jiawen Wu <jiawenwu@trustnetic.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <5B88318B-4944-43CB-8EF6-4942A2696480@net-swift.com>
References: <20230523030658.17738-1-mengyuanlou@net-swift.com>
 <20230523030658.17738-2-mengyuanlou@net-swift.com>
 <20230523210659.11304cce@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
X-Mailer: Apple Mail (2.3731.500.231)
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvrgz:qybglogicsvrgz5a-3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> 2023=E5=B9=B45=E6=9C=8824=E6=97=A5 12:06=EF=BC=8CJakub Kicinski =
<kuba@kernel.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Tue, 23 May 2023 11:06:51 +0800 Mengyuan Lou wrote:
>> + if (skb->encapsulation) {
>> + union network_header hdr;
>> +
>> + switch (first->protocol) {
>> + case htons(ETH_P_IP):
>> + tun_prot =3D ip_hdr(skb)->protocol;
>> + if (ip_is_fragment(ip_hdr(skb)))
>> + return WX_PTYPE_PKT_IP | WX_PTYPE_TYP_IPFRAG;
>> + ptype =3D WX_PTYPE_TUN_IPV4;
>> + break;
>> + case htons(ETH_P_IPV6):
>> + wx_get_ipv6_proto(skb, skb_network_offset(skb), &tun_prot);
>> + if (tun_prot =3D=3D NEXTHDR_FRAGMENT)
>> + return WX_PTYPE_PKT_IP | WX_PTYPE_PKT_IPV6 |
>> +       WX_PTYPE_TYP_IPFRAG;
>> + ptype =3D WX_PTYPE_TUN_IPV6;
>=20
> Why does the HW care about fragmented packets?
> AFAIU fragmented packets won't have any offloads enabled.
>=20
>=20
According to hardware spec(Packet type table), try to tell the ptypes =
for hardware.



