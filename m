Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8025D6CFE32
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 10:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbjC3I0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 04:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjC3I0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 04:26:39 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2063.outbound.protection.outlook.com [40.107.244.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8381727;
        Thu, 30 Mar 2023 01:26:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dSaneOVhN5UNwiOJV9D1wws6p4rzTOnIylUZlhuxYcSOgw8Nc64B32U2tmqhWqn3D/m8Z9XQVfkrYlu5Qk2HHFjZ9kClByRWSfwXeW/T9OrSlm31+JKxPyLMtT2ieXJ9vJh8ZBgsWGnUyDlAwUo3TrxoWkZMtlawQqBgLLo2HIuXPZ7GEi/cbVRJURhsyHseyLonF7DKYfJnqxLxRk4rPtH8kem4ilu2bcqeSDdKJpcYNWroAEC4o6u4bbSD/EutwkhQDv8rq9M9X0fOqM+jpE2MRlsdn0J5uDKUB5CQT/Libt3Hh/q8QtfngGnK7UZFluK0fVfz4OsDpbfxJxkNXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lL3xyVXxbMYYr3/KoZpTH/Vtl9Nw8pGM1vxJayjU34U=;
 b=RFp0P8OVVhmONfN/fcsQpFpV0g6julTC6GWxzLKWlgWmMPUmLLpDP0b85XMGj7x44ENGA5MIGCR9edMi1EdoEmBGiS1c+PPAsCPY+8huOPUXoM7rPk4CWLP49lXFyv5oyV8FUycFL4SC7kKqft6NBA1vk9gkCsi7w8aFlsZv+ztdVtPEIR8JInZ0H0CiJqsO9XIbPFg4vKWJ29mKxCu/G2rrd0uodAGrP5UbInXsqkFvPIe+hopwA0Ifc+wBW+BGnnZq3dJW3Ui/wN03s7mCQueDvAT9M5tlRAdOU6m269bNv4gTWnlCUuvBsvLgooYj8btsJ3tfCJFpCvaFSgJQjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lL3xyVXxbMYYr3/KoZpTH/Vtl9Nw8pGM1vxJayjU34U=;
 b=PGqYKI0fjZRBrW6XQIUyIGz/ePmYaWML3AJ3dpsICV0od+R3WpWtHsYwy0tgS1gyJ+bBwo2NzoG0DZgYHswWT2O+VIPN8H+YeXHJaW4a1S3HnLNEaQeM/X+DV5uWtkuoPeSFaEvuEPzVFwqVeUTKnGmV+Gn4eGWjOxGUJS5WV0+nt5heoAuZVzZ8OfxGuFI4a2ab7abHkUexXYQjwoKppCv5zfmcbGU7sf6EH01dyQ99dh2/IPupATOpzl1T0hiPcQ/Pj2J3+eW/62GQE91hH/1nCUxP4cPWeEqHulfWH578nmZjlBp3AYZMADdjo6QYOl1Ox1gm1PdjA1Jeil5hVQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DS0PR12MB6654.namprd12.prod.outlook.com (2603:10b6:8:d1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.32; Thu, 30 Mar
 2023 08:26:36 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6254.022; Thu, 30 Mar 2023
 08:26:36 +0000
Date:   Thu, 30 Mar 2023 11:26:30 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Amit Cohen <amcohen@nvidia.com>, mlxsw@nvidia.com,
        linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH net-next 6/6] mlxsw: pci: Add support for new reset flow
Message-ID: <ZCVHtk/wqTAR4Ejd@shredder>
References: <ZCBOdunTNYsufhcn@shredder>
 <20230329160144.GA2967030@bhelgaas>
 <20230329111001.44a8c8e0.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329111001.44a8c8e0.alex.williamson@redhat.com>
X-ClientProxiedBy: VI1PR0802CA0008.eurprd08.prod.outlook.com
 (2603:10a6:800:aa::18) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DS0PR12MB6654:EE_
X-MS-Office365-Filtering-Correlation-Id: b7003877-7381-458e-7528-08db30f87a0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UarWGEcvxytAPN2pK4P/8rLma9PPK4LOZrkaQ6ocmNI62Tt6+Wf84jBnwak36Aq1xVWBkDvcKiZDjjXpya26qm+cGZ6RwvOSEVJu5wnWp0gQ+o8vM9EVPzayRvppvtECF8mlIKAY4giaSsHVUmevJbHUwk+LfuNuMOLFkWlL9RGPIKmn1Vq6yYl0x8cNAZc8I/fLXufPta/81CHTaapJ36zjJQb+8yDJ+ttHN0yUkJ249TMWy2TT9ss3YRNPX4reVYsRxoKvhDYNhHHf/6MG4fmpy2UuHOZslbmUgJx8AJadKMAtkbSZNZFNiiU8k20ALjwATT85B6NS4iewQJDku8Fj7kE4Fnr7O5WvOqI3OshTothlEnYl+YUsH+cHJ7NI8wZrqinJufP+dUHRgsC8vIgJDIXA529znyyjaEcebOxjr+WUAHdzT6lvBedJ6PG95zSB3gaailS1YS3kfuuLgVtFMCYghnor3MTIbWU42JsqNuEgM994h90ZRMbvi7abSnnnw/qFzfDKNRkDOvoN8nUaF1sSEH0h96C2A/5RoYohDCg6rFz/IY8R5Z1NQk0X
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(39860400002)(136003)(396003)(366004)(376002)(346002)(451199021)(86362001)(33716001)(2906002)(6486002)(4326008)(54906003)(6666004)(83380400001)(38100700002)(6512007)(9686003)(66556008)(478600001)(66946007)(316002)(66476007)(6506007)(8676002)(6916009)(186003)(5660300002)(26005)(8936002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YV72A6F2sfJEqd6iXT0F0rtN56WiHZ9oXqDwAr9F66R0PBLjKRTCj4FFL0IS?=
 =?us-ascii?Q?PqrwnPu3hBpVsTrJaAU54Q4M68MnuJ8mFOKQ8UJFO4u0w6FErhU0jkWw+iff?=
 =?us-ascii?Q?RTjRRklxw3EEYtwjM5Looj9Se5CG/NrVKeV81G9rSR4Jc5ifLwA7tKGNemky?=
 =?us-ascii?Q?Mu/m/ARv4lywqy0DjgXCza9zAF9k/UfFrjvFnlIRgp6ayzLYLBNZ1AK/2q/0?=
 =?us-ascii?Q?VgTzThVU2fTy28SKHlbyQDJrHzSOgBqx+oKPjj9kQvAcCey/WNs2MyKP2Aad?=
 =?us-ascii?Q?pv0tauLfdk1og0BASpTB0mL5kOymIV+sF38qEB1y0aYNhdweaen6bMFWLqzn?=
 =?us-ascii?Q?55tkb32PwtdCaz3N9IS1Lft1oPT8h0GWSjhEpSOi3+46AeaD3DJNajAW8Y+j?=
 =?us-ascii?Q?P0EOLl9+9mhVoiU/9VYoJy3RLF66+S/2vJy9o/ClIL2nOvbVm9rXL+O37m03?=
 =?us-ascii?Q?vmhyZIVXe16FVazXP650TqYw3q0GuXYR59zJMTlvAsbm0LMo8BfXnlrG+TvQ?=
 =?us-ascii?Q?eaqYkLh8VqtGgS4aP/lJZToViDLOhzVeMizT95nErzkEeIOSqS3qKJkiwL/i?=
 =?us-ascii?Q?CefxfWqFXUMmlsO+7QTwyQYF/oO6cLIBCpD+DfloJamzFNQnlzTgPJuXauGR?=
 =?us-ascii?Q?iLmfWpk5T/5a3tzmtt0Y4HGdRUOOlFePVVPjQBydB3ulMCUkl9+AUWbV/m/H?=
 =?us-ascii?Q?/iKytMDa7H6DkTpOk6TsxV7IxSWxr5PVsKxtQC8c/92n4Y1qVhVfJAmC0Z+F?=
 =?us-ascii?Q?XTN9XYcd8dneZb4QbeGxotxiPrysMlzsZaQVmeUu/DaOLvbzUPywKiUtg3ce?=
 =?us-ascii?Q?FHkMaqco8LJfNdJdsy0NreWuDvEB/xz24yZetO0+u0mf+YJEhDLL3R/odhx9?=
 =?us-ascii?Q?43CmX8k7JEp7jVZqhr8zAkyl41tHTb49JR3fit42MQk2wcui9/yNYg+cmGAH?=
 =?us-ascii?Q?IM4jwpuUYLu/wWyGT3PgpDMn/0ZECxsjv8z278815GgvNAHrjp8OdgNvIeRN?=
 =?us-ascii?Q?K568FVUks6AQ9aBp4JXJzk+F2zVF2dHhwelkNd+zqBaxS6R7PCIgJN7rl108?=
 =?us-ascii?Q?axhe7BMiBToA4UoD7Ld9l0IiIwyqEw/ijEwQLtKGoYqLCNxrXMxzWFu/1LeN?=
 =?us-ascii?Q?XXKshztzoww3HQ5iNPi/ZBWfDo+LXftE8oi8v88XGYIXEd/Y8QG/zAp4S5JJ?=
 =?us-ascii?Q?SQpkB3JwXjRnD6B72PPyDv5ltOeqEFsSQt+5OhxYNe12RIA6uM/fHO6DFs8u?=
 =?us-ascii?Q?OF+ykQOD1xM2HEdV0/wuMiN2/AXpXCKv5oem/pdWQnqY9+2C2q0ErH9m5Y/Q?=
 =?us-ascii?Q?ZqivqM7uXys/IzsYAtV+FQtyyHBSKNJU6ITyov94F3KDS3i3YXQEXOTE2XJ3?=
 =?us-ascii?Q?deZT+rGko2cZjFGbLj+8gpBjy/bqU3ScZ6/Rl3ywo+kpW+vMe6IUoob6y4ZY?=
 =?us-ascii?Q?VMfRS2NMDqRasvKp4/dSNBhiN2I6RFgPy7zGY6nUdNeqpybgUcCpWjo75WgT?=
 =?us-ascii?Q?IFuehJbUparXdQjZ7t+4u1s01sHGT6ypyqbORAq79/oA14n5lydSxy7HGee2?=
 =?us-ascii?Q?RI9i9ErV6mb4zJ8iytSuiqqBO/aILmxbtjeoynaF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7003877-7381-458e-7528-08db30f87a0d
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 08:26:36.2453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o//zc+a1eN3JlHWJI44ob5qnxRePj8Aml43N78gvymEhOtpjW2HUFVC80eY2QBLJtzc1zM0OmkqfEjMMi5UAcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6654
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 11:10:01AM -0600, Alex Williamson wrote:
> I think we don't have it because it's unclear how it's actually
> different from a secondary bus reset from the bridge control register,
> which is what "bus" would do when selected for the example above.  Per
> the spec, both must cause a hot reset.  It seems this device needs a
> significantly longer delay though.

Assuming you are referring to the 2ms sleep in
pci_reset_secondary_bus(), then yes. In our case, after disabling the
link on the downstream port we need to wait for 500ms before enabling
it.

> Note that hot resets can be generated by a userspace driver with
> ownership of the device and will make use of the pci-core reset
> mechanisms.  Therefore if there is not a device specific reset, we'll
> use the standard delays and the device ought not to get itself wedged
> if the link becomes active at an unexpected point relative to a
> firmware update.  This might be a point in favor of a device specific
> reset solution in pci-core.  Thanks,

I assume you referring to something like this:

# echo 1 > /sys/class/pci_bus/0000:03/device/0000:03:00.0/reset

Doesn't seem to have any effect (network ports remain up, at least).
Anyway, this device is completely managed by the kernel, not a user
space driver. I'm not aware of anyone using this method to reset the
device.

If I understand Bjorn and you correctly, we have two options:

1. Keep the current implementation inside the driver.

2. Call __pci_reset_function_locked() from the driver and move the link
toggling to drivers/pci/quirks.c as a "device_specific" method.

Personally, I don't see any benefit in 2, but we can try to implement
it, see if it even works and then decide.

Please let me know what are your preferences.

Thanks
