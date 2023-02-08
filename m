Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E6368EE94
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 13:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbjBHMJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 07:09:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjBHMJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 07:09:31 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2105.outbound.protection.outlook.com [40.107.94.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573EC4C2A
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 04:09:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UGkNongox8Q1zGeq5VtVeIvIH0ptKAq9z+PdVuGh+wKZ0ZjR8OG7xVirZb/7PPAs/JZXU0CFCumuZXK3z4AgrIWKYVccrDERoz+AfwA+w6n+U2p/G0oWBBAVHqKGaz5zM/k9H7xK7Mbh+fEKRIMLjXO1oNTv/XtIq+cPXKseCc5mrQyunGescjpWrin8HUIx5Akc0OvpPZre9xq4jbosuLERB0wJ9pfKXAsRXtqLWPZbqwG6Ph8RAJM9mP9nouWMZs9SDuuenyzHh5cU4K6ZC581gW4DNEoN3guEgoghv8h5onAH+kBOFhl3dI6lYBhGenj1Wg/Gtn8dw3Qr573Sjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=70SQjmrSlhUsxsVBscEmMXbSK+AOU/tLKmsUNHckwGg=;
 b=UDgyOrIuDtSNhWyRsMxRXQ9+9e9dRG60zJ7zCwLmYHIqjbzsfzMFnmzWYGcWyuTqJ8Lx0CgASwWf6hiREHeVbmCfJzTIjzWyqzbwAfhtbW/ff+BLg2ExXJOkgNiVDD6PyuVGVz2OPm1yZ+UfM8pzdVjIEKg4MqikEiHx/10Kwqf8V9SQvrpO6ekxl4p1fp8Ha4k7T2muWfXNs/onxCzajpDS7uBOBnjurcm5TfNshTEGmVKF+/s0ksEOgSRevH03J0EId+Zx2PkjtIBYAZL4gWMBGOe6PmXFPTE+yVIuAdHfHaA0FFjHqFVcIoydAd5vAT+voEGYw9OnLf7dx1shbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=70SQjmrSlhUsxsVBscEmMXbSK+AOU/tLKmsUNHckwGg=;
 b=eP0oo0+iTdukjRQx5kvi1am6hl6u3I/JEcnpvbMN1zq1sVwZSmxsFPFTxYfObeJojjivmpbs+G1KwqILWq/a+Ss7VZ2pmzCmLl9b9dtA7z49oGg+I/vuJgl/3CCe2XORECCGm/eXklaudOE5yryBc8zdHiTlAKYq3wvqavHh8dA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5998.namprd13.prod.outlook.com (2603:10b6:510:16d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Wed, 8 Feb
 2023 12:09:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 12:09:26 +0000
Date:   Wed, 8 Feb 2023 13:09:18 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, Fei Qin <fei.qin@corigine.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: Re: [PATCH/RFC net-next 1/2] devlink: expose port function commands
 to assign VFs to multiple netdevs
Message-ID: <Y+OQ7mnoRux2VGdD@corigine.com>
References: <20230206153603.2801791-1-simon.horman@corigine.com>
 <20230206153603.2801791-2-simon.horman@corigine.com>
 <20230206184227.64d46170@kernel.org>
 <Y+OFspnA69XxCnpI@unreal>
 <Y+OJVW8f/vL9redb@corigine.com>
 <Y+OKeVE9jaoL4qhf@nanopsycho>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+OKeVE9jaoL4qhf@nanopsycho>
X-ClientProxiedBy: AM0PR08CA0015.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5998:EE_
X-MS-Office365-Filtering-Correlation-Id: 44b4a0bc-5526-4aad-7906-08db09cd525d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w5wpVxwTapIbl0DKd/Pvt74Fz5UQjx6P3NIfKYQRb99EcTK/g66f3h4COnpmXlWjoBGkqrjmFAPxuWtlqSX+FkEWi2LrvDnfAVAy4HGlgW3k5ltUJCbTqWRG3VWewxTYu6sVWISXXyHnPkUexxSA33ML4JcbEpmfpWE50VqoHEwXPQXaEAytN08rB9kNclAh7VHLGtZ0ygogGRyrmShjXK1ix/B6NXwzV2rqxO10cvS8C/Ythyb7RaJMb6vMXMF6YNMxx74T2nscHfhSRFD7fQF0s6k/zCSfeEnkoLsdfx0seBooTi690gh1AbHA3Mgbq6rKqPMEPKxv8LLrq0xpTVe9mqG7j2ZtGL6Nx7KqCnSogTGARuN8gfyeXAzkHWOr9ArR2rkltxo02gnxEmfP9Qtsc3j0aVIG1dHUDXzg3i6K6fpjExw9+HmQ+QDLbQ7cY+b3oDbdcOBrLVDw79wCTbVVLLB6B9v43rKw2wvNuyKYXKIflvkXGFIBD80naya0ukjB3UwOSRZdWadps0CPVtdK7LqO9GVQM/fygiss9fNWic2i7EEcblFyvs3vxqiV85wPZObKBN78C4NURRd5CjIKBE1hTGixXprz+MrtOosvpfo0J3XbmQdZgNkGDNdERoNokF/Ajh9eEOrixId9QiN7PxzNPbNTTbI9zC7KR619flgPItxRE2/Qrv1fQ7AHekveR3EV4t2ZmyV2uNykFcH/axGm3LpYfwQFXhDea3U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(396003)(39840400004)(366004)(451199018)(66556008)(4326008)(6916009)(8676002)(66476007)(66946007)(6506007)(186003)(8936002)(41300700001)(6512007)(478600001)(6486002)(86362001)(316002)(6666004)(54906003)(107886003)(2906002)(5660300002)(7416002)(44832011)(36756003)(2616005)(38100700002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KU2ArKCDpB405NCgQwe0qrh6Lx+70aJsWuBBudgBxKRAsryJ4cSvA5/9OGzP?=
 =?us-ascii?Q?U9VeC2rS7Hr7KTq0laxSvfcOK9yaMixTAFAIbpxaq7mue8Y7Om9Ow1mcAJHs?=
 =?us-ascii?Q?NVJNKUQGw4bnGmq/zeCBedNcphYu8HPVpWi3hCuYdNkmQk/kE+HXa0SeQGdk?=
 =?us-ascii?Q?M6EBfdhhE0orxknYbw8BB+miRV17qP7QJIy6kfvwSXXLH2jYM8Z+yAeo/+/Y?=
 =?us-ascii?Q?kK+eOi/LLK5UU54PSl+SqsKwrN6OzlTnecHShZqgeQeD5ZFSX52MCXt7UDZt?=
 =?us-ascii?Q?HhGR5PHJ5GcQ6XnC0dlTReSGMA+/RpFmOFVNMqIaOzl0K34QOhkpBgQXtj4f?=
 =?us-ascii?Q?cI1ObHAY3TWbXYWN8sA8hgEMj3lheLRUVEsjZB37dBox4Ew7Gyh3fMKTObE1?=
 =?us-ascii?Q?iZeD1AqMC31sbA7LJe021AFK52FJpkZDH77bHXmTWkrzjy3UVe/ZZH9BVYMz?=
 =?us-ascii?Q?DiqF0OspClXYa3WjE+etNBllXW4EwycbvXbd6qauW8Li6sfnaPkH+eJTOyoF?=
 =?us-ascii?Q?1AN/1eXzsE/DEagNjNKvSgbdPcMMG2Gaq56bur8vgejm6lF3HqmhFQIrvQhO?=
 =?us-ascii?Q?2gH0p8P20R42lcRqPf1d8+t2g3cVPy78avYVpyIXuGAMYsZjZaIoZpZEroVu?=
 =?us-ascii?Q?3IDHcj8hq5X2YGNlKVrPcstN2pSFNI3eRrrm73RxWaTQPA/RFaiJr4QuRCMv?=
 =?us-ascii?Q?X+rzFmXpPLUxSY3qlWJMVj2fsUu7FJbhNarFlJCilzWarQDtWk0CjFyGbxTU?=
 =?us-ascii?Q?lS6jpMSx6Up/I6S4wMHwN/meQ1tf0hXL40SPJ1sTd4Ftc4+atBaW3jmiN0Nx?=
 =?us-ascii?Q?MqEGRu+lgSviaDZjyMKd3YPP+sncxYGF7DBkizTYqrBoGZYMsncZSg71/wsk?=
 =?us-ascii?Q?hdQXaucEq6z/AQJqc5G+DmseXlTUluCweEg5tQ58X1mwFz+cvdMIYGwkQDcg?=
 =?us-ascii?Q?nhN7h+Jo901/VL/KP2/iNOKIOxCVLahwyFGvAkBbQdT6yQ5O60MhiC+HpPKw?=
 =?us-ascii?Q?+PaDHCFImlskL0+5hSBSGKiCh3eQnF5h30ytHu8XIsK9VVWyRLtgva2zZdlT?=
 =?us-ascii?Q?S0qatzjS42BNBAwiv5ch2X6T87DY707Ny2VX5mx7b09nM+VXz2f23SRC5e2w?=
 =?us-ascii?Q?QFv7qq6RzZW2CYADGJiPb1kx5+brfPtk9m/ORpsSzCF5Hq/6nAwJdYYfsMyY?=
 =?us-ascii?Q?B994kw/LsPU6uzsun5R90+1Mp0EwrHgApxSQKUojiEQCn38q4sQVEjx7uhGL?=
 =?us-ascii?Q?d9tFw51U87MtRYJ5fMKktwfCHEIZSTP5x9kVrwySEqKivKFj5lT1sC4oNpMz?=
 =?us-ascii?Q?2GW/ArWlvB1lBdmomSFgooB7bDTXgzEcM3mX6UCFTHY8JTge2yej9ObDW9Pw?=
 =?us-ascii?Q?I2GH41VyeurXZwNpv23EKpKSskuE8VSJnHNrn4lE7UHm66qLON7AQqICq6NU?=
 =?us-ascii?Q?0xyKTLger+xrzmxuFVoS3MUoNxJ9ppcw+mAoTIRoN5JCY2/ORBl0xUQhnegs?=
 =?us-ascii?Q?ySSZcO9GUkgTv3x5LLd4qis7I22Lr+ngNg9xyFK5VWTp4UR///xRP+ZE9/s8?=
 =?us-ascii?Q?0jBjId2S8q5MZs0XdpLzE1B9zc3+KDL3SNhP2sgloRzf1f+cimuwsw3/8E+W?=
 =?us-ascii?Q?t862f6fACl4dpcTlfGppGzudcLmF6PxNJ+0Gi0qsEuCcwRFAY9uZDdJYLHmx?=
 =?us-ascii?Q?hDihaw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44b4a0bc-5526-4aad-7906-08db09cd525d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 12:09:25.9266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 34y9gDs9HTSyIUtBnOXT6zV2v0W5u15UXvU5FDv+kQLm4QI8DuJeFD2JwUgDgn6ia4r3YHWkEuVI2iLs+QDvJ/oZEfSyRvBvQVfD1osF8/I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5998
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 12:41:45PM +0100, Jiri Pirko wrote:
> Wed, Feb 08, 2023 at 12:36:53PM CET, simon.horman@corigine.com wrote:
> >On Wed, Feb 08, 2023 at 01:21:22PM +0200, Leon Romanovsky wrote:
> >> On Mon, Feb 06, 2023 at 06:42:27PM -0800, Jakub Kicinski wrote:
> >> > On Mon,  6 Feb 2023 16:36:02 +0100 Simon Horman wrote:
> >> > > +VF assignment setup
> >> > > +---------------------------
> >> > > +In some cases, NICs could have multiple physical ports per PF. Users can assign VFs to
> >> > > +different ports.
> >> > 
> >> > Please make sure you run make htmldocs when changing docs,
> >> > this will warn.
> >> > 
> >> > > +- Get count of VFs assigned to physical port::
> >> > > +
> >> > > +    $ devlink port show pci/0000:82:00.0/0
> >> > > +    pci/0000:82:00.0/0: type eth netdev enp130s0np0 flavour physical port 0 splittable true lanes 4
> >> > 
> >> > Physical port has VFs? My knee jerk reaction is that allocating
> >> > resources via devlink is fine but this seems to lean a bit into
> >> > forwarding. How do other vendors do it? What's the mapping of VFs
> >> > to ports?
> >> 
> >> I don't understand the meaning of VFs here. If we are talking about PCI
> >> VFs, other vendors follow PCI spec "9.3.3.3.1 VF Enable" section, which
> >> talks about having one bit to enable all VFs at once. All these VFs will
> >> have separate netdevs.
> >
> >Yes, that is the case here too (before and after).
> >
> >What we are talking about is the association of VFs to physical ports
> >(in the case where a NIC has more than one physical port).
> 
> What is "the association"?

My current explanation - and I'm sure I can dig and find others - is
to association == plugged into same VEB. But I feel that description
will lead to further confusion :(
